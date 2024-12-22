require "spec_helper"

describe Rapidfire::AttemptsController do
  before do
    @routes = Rapidfire::Engine.routes
  end

  # this scenario is possible when there is only 1 radio button question, and
  # user has not selected any option. in this case, browser doesn't send
  # any default value.
  context "when no parameters are passed" do
    it "initializes answer builder with empty args" do
      survey = FactoryBot.create(:survey)

      expect {
        post :create, params: { survey_id: survey.id }
      }.not_to raise_error
    end
  end
end
