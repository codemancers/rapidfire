require 'spec_helper'

describe "Surveys" do
  include Rapidfire::QuestionSpecHelper
  include Rapidfire::AnswerSpecHelper

  let(:survey)  { FactoryGirl.create(:survey, name: "Question Set") }
  let(:question1)  { FactoryGirl.create(:q_long,  survey: survey, question_text: "Long Question")  }
  let(:question2)  { FactoryGirl.create(:q_short, survey: survey, question_text: "Short Question") }
  before(:each) do
    [question1, question2]
  end

  describe "INDEX Surveys" do
    before(:each) do
      visit rapidfire.root_path
    end

    it "lists all surveys" do
      expect(page).to have_content survey.name
    end
  end

  describe "DELETE Surveys" do
    context "when user can administer" do
      before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(true)

        visit rapidfire.root_path
        click_link "Delete"
      end

      it "deletes the survey" do
        expect(page).not_to have_content survey.name
      end
    end

    context "when user cannot administer" do
      before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(false)
        visit rapidfire.root_path
      end

      it "doesn't show option to delete survey" do
        expect(page).not_to have_link "Delete"
      end
    end
  end

  describe "CREATING Survey" do
    context "when user can create groups" do
      before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(true)

        visit rapidfire.root_path
        click_link "New survey"
      end

      context "when name is present" do
        before(:each) do
          page.within("#new_survey") do
            fill_in "survey_name", with: "New Survey"
            click_button "Create Survey"
          end
        end

        it "creates survey" do
          expect(page).to have_content "New Survey"
        end
      end

      context "when name is not present" do
        before(:each) do
          page.within("#new_survey") do
            click_button "Create Survey"
          end
        end

        it "fails to create survey" do
          page.within("#new_survey") do
            expect(page).to have_content "can't be blank"
          end
        end
      end
    end

    context "when user cannot create groups" do
      before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(false)
        visit rapidfire.root_path
      end

      it "page shouldnot have link to create groups" do
        expect(page).not_to have_link "New Group"
      end
    end
  end

  describe "EDITING Surveys" do
    context "when user can manage questions" do
      before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(true)

        visit rapidfire.root_path
        click_link survey.name
      end

      it "shows set of questions" do
        expect(page).to have_content question1.question_text
        expect(page).to have_content question2.question_text
      end
    end

    context "when user cannot manage questions" do
      before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return(false)
      end

      it "fails to access the page" do
        expect(page).not_to have_link survey.name
      end
    end
  end

  describe "GET Survey results" do
    before(:each) do
      create_questions(survey)
      create_answers

      visit rapidfire.root_path
      page.within("#survey_#{survey.id}") do
        click_link "Results"
      end
    end

    it "shows results for particular survey" do
      expect(page).to have_content "Results"
      expect(page).to have_content "hindi 3"
    end
  end
end
