module Rapidfire
  class QuestionsController < ApplicationController
    before_filter :find_question_group!

    def index
      @questions = @question_group.questions
    end

    private
    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end
  end
end
