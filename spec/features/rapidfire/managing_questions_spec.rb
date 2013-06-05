require 'spec_helper'

describe "Questions" do
  let(:question_group)  { FactoryGirl.create(:question_group, name: "Question Set") }
  let(:question1)  { FactoryGirl.create(:q_long,  question_group: question_group, question_text: "Long Question")  }
  let(:question2)  { FactoryGirl.create(:q_short, question_group: question_group, question_text: "Short Question") }
  before(:each) do
    [question1, question2]
  end

  describe "DELETE Question" do
    before(:each) do
      ApplicationController.any_instance.stub(:can_administer?).and_return(true)
      visit rapidfire.question_group_questions_path(question_group)

      page.within("#question_#{question1.id}") do
        click_link "Delete"
      end
    end

    it "deletes the questions" do
      expect(page).not_to have_content question1.question_text
    end
  end

  describe "CREATING Question" do
    before(:each) do
      ApplicationController.any_instance.stub(:can_administer?).and_return(true)
      visit rapidfire.question_group_questions_path(question_group)
      click_link "New Question"
    end

    context "when name is present" do
      before(:each) do
        page.within("#new_question") do
          fill_in "question_question_text",  with: "Which OS?"
          fill_in "question_answer_options", with: "mac\r\nwindows"
          click_button "Create Question"
        end
      end

      it "creates question" do
        page.should have_content "Which OS?"
      end
    end

    context "when name is not present" do
      before(:each) do
        page.within("#new_question") do
          click_button "Create Question"
        end
      end

      it "fails to create question group" do
        page.within("#new_question") do
          page.should have_content "can't be blank"
        end
      end
    end
  end

  describe "UPDATING Question" do
    before(:each) do
      ApplicationController.any_instance.stub(:can_administer?).and_return(true)
      visit rapidfire.question_group_questions_path(question_group)
      page.within("#question_#{question1.id}") do
        click_link "Edit"
      end
    end

    context "when name is modified" do
      before(:each) do
        page.within("#edit_question_#{question1.id}") do
          fill_in "question_question_text",  with: "Updated Question"
          click_button "Update Question"
        end
      end

      it "updates question" do
        page.within("#question_#{question1.id}") do
          page.should have_content "Updated Question"
        end
      end
    end

    context "when name is not present" do
      before(:each) do
        page.within("#edit_question_#{question1.id}") do
          fill_in "question_question_text",  with: ""
          click_button "Update Question"
        end
      end

      it "fails to update question" do
        page.within("#edit_question_#{question1.id}") do
          page.should have_content "can't be blank"
        end
      end
    end
  end
end
