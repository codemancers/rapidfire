require 'spec_helper'

describe Rapidfire::Survey do
  include Rapidfire::QuestionSpecHelper

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:questions) }
  end

  describe "factory" do
    let(:survey) { FactoryGirl.create(:survey) }

    it "has a name" do
      expect(survey.name).to eql("Test Survey")
    end

    it "creates questions" do
      last_question = create_questions(survey)
      expect(last_question.survey).to eql(survey)
      expect(last_question.question_text).not_to be_nil
      expect(last_question.question_text).to eql("Sample Question")

      qs = survey.questions.to_a
      expect(qs).not_to be_empty
      final_question = qs[-1]
      expect(final_question).not_to be_nil
      expect(final_question).to eql(last_question)
      expect(final_question.question_text).not_to be_nil
    end
  end

end
