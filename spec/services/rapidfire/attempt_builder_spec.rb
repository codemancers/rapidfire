require "spec_helper"

def fixture_file_upload(path, mime_type)
  Rack::Test::UploadedFile.new(Pathname.new(file_fixture_path).join(path), mime_type, false)
end

describe Rapidfire::AttemptBuilder do
  let(:survey) { FactoryBot.create(:survey) }
  let(:question1) { FactoryBot.create(:q_short, survey: survey) }
  let(:question2) { FactoryBot.create(:q_long, survey: survey, validation_rules: { presence: "1" }) }

  describe "Creation" do
    let(:builder) { described_class.new(survey: survey) }
    before { [question1, question2] }

    it "builds answer group with answers" do
      expect(builder.answers).not_to be_empty
    end

    it "builds answers based on the number of questions available" do
      questions = builder.answers.collect { |a| a.question }
      expect(questions).to match_array([question1, question2])
    end
  end

  describe "#save" do
    let(:question_ids) { survey.questions.map(&:id) }
    let(:answer_params) do
      {
        question1.id.to_s => { answer_text: "short answer" },
        question2.id.to_s => { answer_text: "long answer" },
      }
    end
    let(:builder) do
      params = { params: answer_params, survey: survey }
      described_class.new(params)
    end
    let(:save_answers) { builder.save }

    context "when all the answers are valid" do
      it "returns true" do
        expect(save_answers).to be_truthy
      end

      it "successfully saves answers" do
        save_answers
        builder.answers.each do |answer|
          expect(answer).to be_persisted
          expect(question_ids).to include(answer.question_id)
        end
      end
    end

    context "when some of the answers are invalid" do
      let(:answer_params) do
        {
          question1.id.to_s => { answer_text: "short answer" },
          question2.id.to_s => { answer_text: "" },
        }
      end

      it "returns false" do
        expect(save_answers).to be_falsey
      end

      it "fails to save those answers" do
        save_answers
        expect(Rapidfire::Answer.count).to eq(0)
      end
    end

    context "when requested to save without validations" do
      let(:save_answers) { builder.save(validate: false) }

      it "returns true" do
        expect(save_answers).to be_truthy
      end

      it "saves all the answers" do
        save_answers
        builder.answers.each do |answer|
          expect(answer).to be_persisted
          expect(question_ids).to include(answer.question_id)
        end
      end
    end

    context "with a single file upload question" do
      let(:question3) { FactoryBot.create(:q_file, survey: survey) }

      let(:answer_params) do
        {
          question1.id.to_s => { answer_text: "short answer" },
          question2.id.to_s => { answer_text: "long answer" },
          question3.id.to_s => { file: fixture_file_upload("one.txt", "text/plain") },
        }
      end

      it "saves the file successfully" do
        expect(save_answers).to be_truthy

        answer = Rapidfire::Answer.last
        expect(answer).to be_persisted
        expect(answer.file.download).to eq("one\n")
      end
    end

    context "with multiple files upload question" do
      let(:question3) { FactoryBot.create(:q_multifile, survey: survey) }

      let(:answer_params) do
        {
          question1.id.to_s => { answer_text: "short answer" },
          question2.id.to_s => { answer_text: "long answer" },
          question3.id.to_s => {
            files: [
              fixture_file_upload("one.txt", "text/plain"),
              fixture_file_upload("two.txt", "text/plain"),
            ],
          },
        }
      end

      it "saves the files successfully" do
        expect(save_answers).to be_truthy

        answer = Rapidfire::Answer.last
        expect(answer).to be_persisted
        expect(answer.files[0].download).to eq("one\n")
        expect(answer.files[1].download).to eq("two\n")
      end
    end
  end
end
