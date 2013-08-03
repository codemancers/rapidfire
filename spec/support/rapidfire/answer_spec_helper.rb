module Rapidfire
  module AnswerSpecHelper
    def create_answers
      FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => 'hindi')
      FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => 'hindi,telugu')
      FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => 'hindi,kannada')

      FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'mac')
      FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'mac')
      FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'windows')

      FactoryGirl.create(:answer, :question => @question_radio, :answer_text => 'male')
      FactoryGirl.create(:answer, :question => @question_radio, :answer_text => 'female')

      3.times do
        FactoryGirl.create(:answer, :question => @question_date, :answer_text => Date.today.to_s)
        FactoryGirl.create(:answer, :question => @question_long, :answer_text => 'really long answer')
        FactoryGirl.create(:answer, :question => @question_numeric, :answer_text => 999)
        FactoryGirl.create(:answer, :question => @question_short, :answer_text => 'short answer')
      end
    end
  end
end
