module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!

    before_filter :find_question_group!
    before_filter :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @question_group.questions
    end

    def new
      @question = QuestionForm.new(:question_group => @question_group)
    end

    def create
      form_params = params[:question].merge(:question_group => @question_group)
      @question = QuestionForm.new(form_params)
      @question.save
    end

    def edit
      @question = QuestionForm.new(:question => @question)
    end

    def update
      form_params = params[:question].merge(:question => @question)
      @question = QuestionForm.new(form_params)
      @question.save
    end

    def destroy
      @question.destroy
    end

    private

    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def find_question!
      @question = @question_group.questions.find(params[:id])
    end

    def index_location
      rapidfire.question_group_questions_url(@question_group)
    end
  end
end
