require 'spec_helper'

describe Rapidfire::Questions::Numeric do
  describe "validate_answer" do
    let(:question)  { FactoryGirl.create(:q_numeric, validation_rules: validation_rules) }
    let(:answer)    { FactoryGirl.build(:answer, question: question, answer_text: answer_text) }
    before(:each)   { answer.valid? }

    context "when there are no validation rules" do
      let(:validation_rules) { {} }
      let(:answer_text)      { "" }

      it "answer should pass validations" do
        answer.errors.should be_empty
      end

      context "when there is an answer" do
        context "when answer is valid number" do
          let(:answer_text)   { "24" }

          it "passes validation" do
            answer.errors.should be_empty
          end
        end

        context "when answer is not a valid number" do
          let(:answer_text)   { "sample answer" }

          it "fails validation" do
            answer.errors.should_not be_empty
          end

          it "says answer is invalid" do
            answer.errors[:answer_text].should include("is not a number")
          end
        end
      end
    end

    context "when question should have an answer" do
      let(:validation_rules) { { presence: "1" } }

      context "when answer is empty" do
        let(:answer_text)  { "" }

        it "fails validations" do
          answer.errors.should_not be_empty
        end

        it "says answer should be present" do
          answer.errors[:answer_text].should include("can't be blank")
        end
      end

      context "when answer is not empty" do
        context "when the answer is a number" do
          let(:answer_text)  { "20" }

          it "passes validation" do
            answer.errors.should be_empty
          end
        end

        context "when the answer is not a number" do
          let(:answer_text)  { "sample answer" }

          it "fails validation" do
            answer.errors.should_not be_empty
          end

          it "says answer is not a number" do
            answer.errors[:answer_text].should include("is not a number")
          end
        end
      end
    end

    context "when question should have an answer with >= or <= values" do
      let(:validation_rules) { { greater_than_or_equal_to: "15", less_than_or_equal_to: "25" } }

      context "when answer is less than min value" do
        let(:answer_text)  { "14" }

        it "fails validations" do
          answer.errors.should_not be_empty
        end

        it "says answer is too short" do
          answer.errors[:answer_text].first.should match("must be greater than or equal to")
        end
      end

      context "when answer is in between min and max value" do
        let(:answer_text)  { "20" }

        it "passes validations" do
          answer.errors.should be_empty
        end
      end

      context "when answer is more than max value" do
        let(:answer_text)  { "26" }

        it "fails validations" do
          answer.errors.should_not be_empty
        end

        it "says answer is too long" do
          answer.errors[:answer_text].first.should match("must be less than or equal to")
        end
      end
    end
  end
end
