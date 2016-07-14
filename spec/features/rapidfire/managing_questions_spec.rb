require 'spec_helper'

describe "Questions" do
  let(:survey)  { FactoryGirl.create(:survey, name: "Question Set") }
  let(:question1)  { FactoryGirl.create(:q_long,  survey: survey, question_text: "Long Question")  }
  let(:question2)  { FactoryGirl.create(:q_short, survey: survey, question_text: "Short Question") }
  before do
    [question1, question2]
  end

  describe "DELETE Question" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(true)
      visit rapidfire.survey_questions_path(survey)

      page.within("#question_#{question1.id}") do
        click_link "Delete"
      end
    end

    it "deletes the questions" do
      expect(page).not_to have_content question1.question_text
    end
  end

  describe "CREATING Question" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(true)
      visit rapidfire.survey_questions_path(survey)
      click_link "New Question"
    end

    context "when name is present" do
      before do
        page.within("#new_question") do
          fill_in "question_question_text",  with: "Which OS?"
          fill_in "question_answer_options", with: "mac\r\nwindows"
          click_button "Create Question"
        end
      end

      it "creates question" do
        expect(page).to have_content "Which OS?"
      end
    end

    context "when name is not present" do
      before do
        page.within("#new_question") do
          click_button "Create Question"
        end
      end

      it "fails to create survey" do
        page.within("#new_question") do
          expect(page).to have_content "can't be blank"
        end
      end
    end
  end

  describe "UPDATING Question" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(true)
      visit rapidfire.survey_questions_path(survey)
      page.within("#question_#{question1.id}") do
        click_link "Edit"
      end
    end

    context "when name is modified" do
      before do
        fill_in "question_question_text",  with: "Updated Question"
        click_button "Update Question"
      end

      it "updates question" do
        page.within("#question_#{question1.id}") do
          expect(page).to have_content "Updated Question"
        end
      end
    end

    context "when name is not present" do
      before do
        fill_in "question_question_text",  with: ""
        click_button "Update Question"
      end

      it "fails to update question" do
        expect(page).to have_content "can't be blank"
      end
    end
  end
end
