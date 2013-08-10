require 'spec_helper'

describe Rapidfire::QuestionForm do
  let(:question_group)  { FactoryGirl.create(:question_group) }

  describe "Creation" do
    let(:proxy)  { described_class.new(question_group: question_group) }

    it "builds a dummy question" do
      proxy.question.should_not be_nil
    end

    context "when params are passed" do
      let(:proxy)  { described_class.new(question_group: question_group, question_text: "Your Bio") }

      it "persists those params" do
        proxy.question_text.should == "Your Bio"
      end
    end

    context "when a question is passed" do
      let(:question)  { FactoryGirl.create(:q_checkbox, question_group: question_group) }
      let(:proxy)     { described_class.new(question_group: question_group, question: question) }

      it "persists question params" do
        proxy.type.should == question.type
        proxy.question_group.should == question.question_group
        proxy.question_text.should  == question.question_text
        proxy.answer_options.should == question.answer_options
      end
    end
  end

  describe "#save" do
    before(:each)  { proxy.save }

    context "creating a new question" do
      let(:proxy) { described_class.new(params.merge(question_group: question_group)) }

      context "when question params are valid" do
        let(:params) do
          {
            type:           "Rapidfire::Questions::Checkbox",
            question_text:  "Your mood today",
            answer_options: "good\r\nbad"
          }
        end

        it "persists the question" do
          proxy.errors.should be_empty
        end

        it "creates a question given type" do
          proxy.question.should be_a(Rapidfire::Questions::Checkbox)
        end

        it "persists params in created question" do
          proxy.question.question_text.should == "Your mood today"
          proxy.question.options.should =~ ["good", "bad"]
        end
      end

      context "when question params are invalid" do
        let(:params) do
          { type: "Rapidfire::Questions::Checkbox" }
        end

        it "fails to presist the question" do
          proxy.errors.should_not be_empty
          proxy.errors[:question_text].should  include("can't be blank")
          proxy.errors[:answer_options].should include("can't be blank")
        end
      end
    end

    context "updating a question" do
      let(:question)  { FactoryGirl.create(:q_checkbox, question_group: question_group) }
      let(:proxy) do
        proxy_params = params.merge(question_group: question_group, question: question)
        described_class.new(proxy_params)
      end

      let(:params) do
        { question_text: "Changing question text" }
      end

      it "updates the question" do
        proxy.errors.should be_empty
        proxy.question.question_text.should == "Changing question text"
      end
    end
  end
end
