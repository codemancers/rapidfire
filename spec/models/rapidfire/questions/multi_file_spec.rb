require "spec_helper"

describe Rapidfire::Questions::MultiFile do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:survey) }
    it { is_expected.to validate_presence_of(:question_text) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:survey) }
  end

  describe "validate_answer" do
    let(:question) { FactoryBot.create(:q_multifile, validation_rules: validation_rules) }
    let(:answer) { FactoryBot.build(:answer, question: question, files: files) }
    before { answer.valid? }

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
    end
  end
end
