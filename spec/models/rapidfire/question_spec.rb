require 'spec_helper'

describe Rapidfire::Question do
  describe "Validations" do
    it { should validate_presence_of(:question_group) }
    it { should validate_presence_of(:question_text)  }
  end

  describe "Associations" do
    it { should belong_to(:question_group) }
  end

  describe "#rules" do
    let(:question)  { FactoryGirl.create(:q_long, validation_rules: validation_rules) }

    context "when there are no validation rules" do
      let(:validation_rules) { {} }

      it "returns empty hash" do
        question.rules.should be_empty
      end
    end

    context "when validation rules are present" do
      let(:validation_rules) do
        { :presence => "1" }
      end

      it "returns those rules" do
        question.rules[:presence].should be_true
      end
    end
  end

  describe "validate_answer" do
    let(:question)  { FactoryGirl.create(:q_long, validation_rules: validation_rules) }
    let(:answer)    { FactoryGirl.build(:answer, question: question, answer_text: answer_text) }
    before(:each)   { answer.valid? }

    context "when there are no validation rules" do
      let(:validation_rules) { {} }
      let(:answer_text)      { "" }

      it "answer should pass validations" do
        answer.errors.should be_empty
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
        let(:answer_text)  { "sample answer" }

        it "passes validations" do
          answer.errors.should be_empty
        end
      end
    end

    context "when question should have an answer with min or max length" do
      let(:validation_rules) { { minimum: "10", maximum: "20" } }

      context "when answer is empty" do
        let(:answer_text)  { "" }

        it "fails validations" do
          answer.errors.should_not be_empty
        end

        it "says answer is too short" do
          answer.errors[:answer_text].first.should match("is too short")
        end
      end

      context "when answer is not empty" do
        context "when answer is less than min chars" do
          let(:answer_text)  { 'i' * 9 }

          it "fails validations" do
            answer.errors.should_not be_empty
          end

          it "says answer is too short" do
            answer.errors[:answer_text].first.should match("is too short")
          end
        end

        context "when answer is in between min and max chars" do
          let(:answer_text)  { 'i' * 15 }

          it "passes validations" do
            answer.errors.should be_empty
          end
        end

        context "when answer is more than max chars" do
          let(:answer_text)  { 'i' * 21 }

          it "fails validations" do
            answer.errors.should_not be_empty
          end

          it "says answer is too long" do
            answer.errors[:answer_text].first.should match("is too long")
          end
        end
      end
    end
  end
end
