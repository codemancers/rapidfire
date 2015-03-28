require 'spec_helper'

describe Rapidfire::QuestionForm do
  let(:survey)  { FactoryGirl.build_stubbed(:survey) }

  describe 'Validations' do
    subject { described_class.new(survey) }

    it { should validate_presence_of(:type) }
    it { should validate_inclusion_of(:type)
        .in_array(["Rapidfire::Questions::Checkbox",
                    "Rapidfire::Questions::Date",
                    "Rapidfire::Questions::Long",
                    "Rapidfire::Questions::Numeric",
                    "Rapidfire::Questions::Radio",
                    "Rapidfire::Questions::Select",
                    "Rapidfire::Questions::Short"]) }
  end

  describe "#create" do
    let(:form)  { described_class.new(survey) }

    it 'returns false if form is invalid' do
      expect(form.with_params().create()).to be_falsey
    end

    it 'doesnot create any question if form is invalid' do
      form.with_params().create()
      expect(Rapidfire::Question.count).to be_zero
    end

    let(:params) do
      {
        type:           "Rapidfire::Questions::Checkbox",
        question_text:  "Your mood today",
        answer_options: "good\r\nbad"
      }
    end

    it "creates a question given type" do
      expect(form.with_params(params).create()).to be_truthy
      expect(form.question).to be_a(Rapidfire::Questions::Checkbox)
    end

    it "persists params in created question" do
      expect(form.with_params(params).create()).to be_truthy
      expect(form.question.question_text).to eq("Your mood today")
      expect(form.question.options).to match_array(["good", "bad"])
    end
  end

  describe '#edit' do
    let(:question)  { FactoryGirl.create(:q_checkbox, survey: survey) }
    let(:form)  { described_class.new(survey) }

    it "updates form with question params" do
      form.edit(question)

      expect(form.type).to eq(question.type)
      expect(form.question_text).to  eq(question.question_text)
      expect(form.answer_options).to eq(question.answer_options)
    end
  end

  describe "#update" do
    let(:question)  { FactoryGirl.create(:q_checkbox, survey: survey) }
    let(:form)  { described_class.new(survey) }

    before(:each) do
      form.edit(question)
    end

    it 'returns false if form is invalid' do
      params = { question_text: "" }
      expect(form.with_params(params).update()).to be_falsey
    end

    it 'doesnot create any question if form is invalid' do
      original_text = question.question_text
      params = { question_text: "" }
      form.with_params(params).update()

      expect(question.reload.question_text).to eq original_text
    end

    it "updates the question" do
      params = { question_text: "Changing question text" }

      expect(form.with_params(params).update()).to be_truthy
      expect(question.reload.question_text).to eq("Changing question text")
    end
  end
end
