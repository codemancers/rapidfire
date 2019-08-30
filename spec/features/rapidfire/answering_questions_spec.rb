require 'spec_helper'

describe "Surveys" do
  let!(:survey) { FactoryGirl.create(:survey, name: "Question Set", introduction: "Some introduction") }
  let!(:question1) { FactoryGirl.create(:q_long,  survey: survey, question_text: "Long Question", validation_rules: { presence: "1" })  }
  let!(:question2) { FactoryGirl.create(:q_short, survey: survey, question_text: "Short Question") }
  let!(:question3) { FactoryGirl.create(:q_checkbox, survey: survey, question_text: "Checkbox question") }
  let!(:question4) { FactoryGirl.create(:q_checkbox, survey: survey, question_text: "Checkbox question", validation_rules: { presence: "1" }) }

  before do
    visit rapidfire.new_survey_attempt_path(survey)
  end

  it "displays survey introduction" do
    expect(page).to have_content "Some introduction"
  end

  describe "Answering Questions" do
    context "when all questions are answered" do
      before do
        fill_in "attempt_#{question1.id}_answer_text", with: "Long Answer"
        fill_in "attempt_#{question2.id}_answer_text", with: "Short Answer"
        check "attempt_#{question3.id}_answer_text_1"
        check "attempt_#{question4.id}_answer_text_0"
        click_button "Save"
      end

      it "persists 4 answers" do
        expect(Rapidfire::Answer.count).to eq(4)
      end

      it "persists 4 answers with answer values" do
        expected_answers = ["Long Answer", "Short Answer", "telugu", "hindi"]
        expect(Rapidfire::Answer.all.map(&:answer_text)).to match(expected_answers)
      end

      it "redirects to question groups path" do
        expect(current_path).to eq(rapidfire.surveys_path)
      end
    end

    context "when all questions are not answered" do
      context "when validation fails" do
        before do
          fill_in "attempt_#{question1.id}_answer_text", with: ""
          fill_in "attempt_#{question2.id}_answer_text", with: "Short Answer"
          check "attempt_#{question3.id}_answer_text_1"
          click_button "Save"
        end

        it "fails to persits answers" do
          expect(Rapidfire::Answer.count).to eq(0)
        end

        it "shows error for missing answers" do
          expect(page).to have_content("can't be blank", count: 2)
        end

        it "shows already populated answers" do
          short_answer = page.find("#attempt_#{question2.id}_answer_text").value
          expect(page).to have_checked_field("attempt_#{question3.id}_answer_text_1")
          expect(short_answer).to have_content "Short Answer"
        end
      end

      context "when validation passes" do
        before do
          fill_in "attempt_#{question1.id}_answer_text", with: "Long Answer"
          check "attempt_#{question4.id}_answer_text_0"
          click_button "Save"
        end

        it "persists 4 answers" do
          expect(Rapidfire::Answer.count).to eq(4)
        end

        it "persists 4 answers with 2 empty answers" do
          expected_answers = ["Long Answer", "", "", "hindi"]
          expect(Rapidfire::Answer.all.map(&:answer_text)).to match(expected_answers)
        end

        it "redirects to question groups path" do
          expect(current_path).to eq(rapidfire.surveys_path)
        end
      end
    end
  end
end
