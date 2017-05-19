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
      p survey
      expect(survey.name).to eql("Survey")
    end

    it "creates questions" do
      last_question = create_questions(survey)
      expect(last_question.survey).to eql(survey)
      qs = survey.questions.to_a
      expect(qs).not_to be_empty
    end
  end

end
