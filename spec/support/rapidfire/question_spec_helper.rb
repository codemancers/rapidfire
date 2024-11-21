module Rapidfire
  module QuestionSpecHelper
    def create_questions(survey)
      @question_checkbox = FactoryBot.create(:q_checkbox, :survey => survey)
      @question_date = FactoryBot.create(:q_date, :survey => survey)
      @question_long = FactoryBot.create(:q_long, :survey => survey)
      @question_numeric = FactoryBot.create(:q_numeric, :survey => survey)
      @question_radio = FactoryBot.create(:q_radio, :survey => survey)
      @question_select = FactoryBot.create(:q_select, :survey => survey)
      @question_short = FactoryBot.create(:q_short, :survey => survey)
    end
  end
end
