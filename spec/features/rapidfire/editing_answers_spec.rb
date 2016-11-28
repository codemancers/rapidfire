require 'spec_helper'

describe "Surveys" do
  let(:survey)  { FactoryGirl.create(:survey, name: "Question Set") }
  let(:question1)  { FactoryGirl.create(:q_long,  survey: survey, question_text: "Long Question", validation_rules: { presence: "1" })  }
  let(:question2)  { FactoryGirl.create(:q_short, survey: survey, question_text: "Short Question") }
  let(:attempt) { FactoryGirl.create(:attempt, survey: survey) }
  let!(:answer1) { FactoryGirl.create(:answer, attempt: attempt, question: question1, answer_text: "Long Answer") }
  let!(:answer2) { FactoryGirl.create(:answer, attempt: attempt, question: question2, answer_text: "Short Answer") }
  before do
    visit rapidfire.edit_survey_attempt_path(survey, attempt)
  end

  describe "Editing Answers" do
    it "shows already populated answers" do
      long_answer = page.find("#attempt_#{question1.id}_answer_text").value
      short_answer = page.find("#attempt_#{question2.id}_answer_text").value
      expect(long_answer).to have_content "Long Answer"
      expect(short_answer).to have_content "Short Answer"
    end

    context "when all questions are answered" do
      before do
        fill_in "attempt_#{question1.id}_answer_text", with: "Updated Long Answer"
        fill_in "attempt_#{question2.id}_answer_text", with: "Updated Short Answer"
        click_button "Update"
      end

      it "persists 2 answers" do
        expect(Rapidfire::Answer.count).to eq(2)
      end

      it "persists 2 answers with answer values" do
        expected_answers = ["Updated Long Answer", "Updated Short Answer"]
        expect(Rapidfire::Answer.all.map(&:answer_text)).to match_array(expected_answers)
      end

      it "redirects to question groups path" do
        expect(current_path).to eq(rapidfire.surveys_path)
      end
    end

    context "when all questions are not answered" do
      before do
        fill_in "attempt_#{question1.id}_answer_text", with: ""
        fill_in "attempt_#{question2.id}_answer_text", with: "Updated Short Answer"
        click_button "Update"
      end

      it "shows error for missing answers" do
        expect(page).to have_content "can't be blank"
      end

      it "shows already populated answers" do
        short_answer = page.find("#attempt_#{question2.id}_answer_text").value
        expect(short_answer).to have_content "Updated Short Answer"
      end
    end
  end
end
