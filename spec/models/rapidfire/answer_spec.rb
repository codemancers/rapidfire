require 'spec_helper'

describe Rapidfire::Answer do
  describe "Validations" do
    subject { FactoryGirl.build(:answer) }
    it { should validate_presence_of(:question)      }
    it { should validate_presence_of(:answer_group)  }

    context "when validations are run" do
      let(:answer)  { FactoryGirl.build(:answer) }

      it "delegates validation of answer text to question" do
        answer.question.should_receive(:validate_answer).with(answer).once
        answer.valid?.should be_true
      end
    end
  end

  describe "Associations" do
    it { should belong_to(:question)     }
    it { should belong_to(:answer_group) }
  end
end
