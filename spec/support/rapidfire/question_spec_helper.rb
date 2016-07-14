module Rapidfire
  module QuestionSpecHelper
    def create_questions(survey)
      @question_checkbox = FactoryGirl.create(:q_checkbox, :survey => survey)
      @question_date = FactoryGirl.create(:q_date, :survey => survey)
      @question_long = FactoryGirl.create(:q_long, :survey => survey)
      @question_numeric = FactoryGirl.create(:q_numeric, :survey => survey)
      @question_radio = FactoryGirl.create(:q_radio, :survey => survey)
      @question_select = FactoryGirl.create(:q_select, :survey => survey)
      @question_short = FactoryGirl.create(:q_short, :survey => survey)
    end
  end
end
