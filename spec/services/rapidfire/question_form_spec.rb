require 'spec_helper'

describe Rapidfire::QuestionForm do
  let(:survey)  { FactoryGirl.create(:survey) }

  describe 'Validations' do
    subject { described_class.new(survey: survey) }

    it { should validate_presence_of(:type) }
    it { should validate_inclusion_of(:type)
        .in_array(["Rapidfire::Questions::Checkbox",
                    "Rapidfire::Questions::Date",
                    "Rapidfire::Questions::Long",
                    "Rapidfire::Questions::Numeric",
                    "Rapidfire::Questions::Radio",
                    "Rapidfire::Questions::Select",
                    "Rapidfire::Questions::Short"]) }

    context 'answer_options validations'
  end

  describe 'Initialization' do
    let(:proxy)  { described_class.new(survey: survey) }

    it "builds a dummy question" do
      expect(proxy.question).not_to be_nil
    end

    context "when params are passed" do
      let(:proxy)  { described_class.new(survey: survey, question_text: "Your Bio") }

      it "persists those params" do
        expect(proxy.question_text).to eq("Your Bio")
      end
    end

    context "when a question is passed" do
      let(:question)  { FactoryGirl.create(:q_checkbox, survey: survey) }
      let(:proxy)     { described_class.new(survey: survey, question: question) }

      it "persists question params" do
        expect(proxy.type).to eq(question.type)
        expect(proxy.survey).to eq(question.survey)
        expect(proxy.question_text).to  eq(question.question_text)
        expect(proxy.answer_options).to eq(question.answer_options)
      end
    end
  end

  describe "#save" do
    context "creating a new question" do
      let(:proxy) { described_class.new(params.merge(survey: survey)) }

      context "when question params are valid" do
        let(:params) do
          {
            type:           "Rapidfire::Questions::Checkbox",
            question_text:  "Your mood today",
            answer_options: "good\r\nbad"
          }
        end

        it "persists the question" do
          expect(proxy.save).to be_truthy
          expect(proxy.errors).to be_empty
        end

        it "creates a question given type" do
          expect(proxy.save).to be_truthy
          expect(proxy.question).to be_a(Rapidfire::Questions::Checkbox)
        end

        it "persists params in created question" do
          expect(proxy.save).to be_truthy
          expect(proxy.question.question_text).to eq("Your mood today")
          expect(proxy.question.options).to match_array(["good", "bad"])
        end
      end

      context "when question params are invalid" do
        let(:params) do
          { type: "Rapidfire::Questions::Checkbox" }
        end

        it "fails to presist the question" do
          expect(proxy.save).to be_falsey
          expect(proxy.errors).not_to be_empty
          expect(proxy.errors[:question_text]).to  include("can't be blank")
          expect(proxy.errors[:answer_options]).to include("can't be blank")
        end
      end
    end

    context "updating a question" do
      let(:question)  { FactoryGirl.create(:q_checkbox, survey: survey) }
      let(:proxy) do
        proxy_params = params.merge(survey: survey, question: question)
        described_class.new(proxy_params)
      end

      let(:params) do
        { question_text: "Changing question text" }
      end

      it "updates the question" do
        expect(proxy.save).to be_truthy
        expect(proxy.errors).to be_empty
        expect(proxy.question.question_text).to eq("Changing question text")
      end
    end
  end
end
