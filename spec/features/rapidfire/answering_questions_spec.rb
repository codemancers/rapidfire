require 'spec_helper'

describe "Surveys" do
  let!(:survey) { FactoryBot.create(:survey, name: "Question Set", introduction: "Some introduction") }

  it "displays survey introduction" do
    visit rapidfire.new_survey_attempt_path(survey)

    expect(page).to have_content "Some introduction"
  end

  describe "Answering Questions" do
    let!(:question1) { FactoryBot.create(:q_long,  survey: survey, question_text: "Long Question", validation_rules: { presence: "1" })  }
    let!(:question2) { FactoryBot.create(:q_short, survey: survey, question_text: "Short Question") }
    let!(:question3) { FactoryBot.create(:q_checkbox, survey: survey, question_text: "Checkbox question") }
    let!(:question4) { FactoryBot.create(:q_checkbox, survey: survey, question_text: "Checkbox question", validation_rules: { presence: "1" }) }

    before do
      visit rapidfire.new_survey_attempt_path(survey)
    end

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
          expect(page).to have_content("can't be blank", count: 3)
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

  if "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}" >= "5.2"
    describe "Answering File uploads" do
      context "when the question is single file upload" do
        let!(:question1) { FactoryBot.create(:q_file,  survey: survey, question_text: "Avatar")  }

        it "persistes the file" do
          visit rapidfire.new_survey_attempt_path(survey)

          attach_file "attempt_#{question1.id}_file", file_fixture("one.txt")
          click_button "Save"

          answer = Rapidfire::Answer.first
          expect(answer).to be_persisted
          expect(answer.file.download).to eq("one\n")
        end
      end

      context "when the question is multi file upload" do
        let!(:question1) { FactoryBot.create(:q_multifile,  survey: survey, question_text: "Images")  }

        it "persistes the file" do
          visit rapidfire.new_survey_attempt_path(survey)

          attach_file "attempt_#{question1.id}_files", [file_fixture("one.txt"), file_fixture("two.txt")]
          click_button "Save"

          answer = Rapidfire::Answer.first
          expect(answer).to be_persisted
          expect(answer.files.length).to eq 2

          expect(answer.files[0].download).to eq("two\n")
          expect(answer.files[1].download).to eq("one\n")
        end
      end

      context "when persisting a file fails" do
        let!(:question1) { FactoryBot.create(:q_file,  survey: survey, question_text: "Avatar")  }

        it "bubbles up the error" do
          visit rapidfire.new_survey_attempt_path(survey)

          expect_any_instance_of(Rapidfire::Answer).to receive("file_attachment=") do
            raise ActiveRecord::ActiveRecordError.new("Can't save the file")
          end

          attach_file "attempt_#{question1.id}_file", file_fixture("one.txt")
          click_button "Save"

          expect(page).to have_content("Can't save the file")
        end
      end
    end
  end
end
