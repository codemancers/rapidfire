require "spec_helper"

describe Rapidfire::QuestionResultSerializer do
  include Rapidfire::QuestionSpecHelper
  include Rapidfire::AnswerSpecHelper

  let(:question_group) { FactoryGirl.create(:question_group) }
  let(:results)  { Rapidfire::QuestionGroupResults.new(question_group).extract }

  before do
    create_questions(question_group)
    create_answers
  end

  describe "#to_json" do
    it "converts to json" do
      p described_class.new(results.first).to_json
    end
  end
end
