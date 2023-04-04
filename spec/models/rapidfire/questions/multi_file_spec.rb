require 'spec_helper'

def fixture_file_upload(path, mime_type)
  Rack::Test::UploadedFile.new(Pathname.new(file_fixture_path).join(path), mime_type, false)
end

describe Rapidfire::Questions::MultiFile do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:survey) }
    it { is_expected.to validate_presence_of(:question_text)  }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:survey) }
  end

  if "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}" >= "5.2"
    describe "validate_answer" do
      let(:question) { FactoryGirl.create(:q_multifile, validation_rules: validation_rules) }
      let(:answer) { FactoryGirl.build(:answer, question: question, files: files) }
      before  { answer.valid? }

      context "when there are no validation rules" do
        let(:validation_rules) { {} }
        let(:files) { [] }

        it "answer should pass validations" do
          expect(answer.errors).to be_empty
        end
      end

      context "when question needs a file attachment" do
        let(:validation_rules) { { presence: "1" } }

        context "when answer is empty" do
          let(:files) { [] }

          it "fails validations" do
            expect(answer.errors).not_to be_empty
          end

          it "says answer should be present" do
            expect(answer.errors[:files]).to include("can't be blank")
          end
        end

        context "when answer is not empty" do
          let(:files) do
            [fixture_file_upload("one.txt", "text/plain"),
             fixture_file_upload("two.txt", "text/plain")]
          end

          it "passes validations" do
            expect(answer.errors).to be_empty
          end
        end
      end
    end
  end
end
