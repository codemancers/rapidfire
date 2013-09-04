module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    respond_to :html, :js

    def index
      @questions = question_group.questions
      respond_with(@questions)
    end

    def new
      @question = QuestionForm.new(new_params)
      respond_with(@question)
    end

    def create
      @question = QuestionForm.new(create_params)
      @question.save

      respond_with(@question, location: index_location)
    end

    def edit
      @question = QuestionForm.new(question: find_question!)
      respond_with(@question)
    end

    def update
      @question = QuestionForm.new(update_params)
      @question.save

      respond_with(@question, location: index_location)
    end

    def destroy
      @question = find_question!
      @question.destroy
      respond_with(@question, location: index_location)
    end

    private
    def question_group
      @question_group ||= QuestionGroup.find(params[:question_group_id])
    end

    def find_question!
      question_group.questions.find(params[:id])
    end

    def new_params
      params.slice(:type).merge(question_group: question_group)
    end

    def create_params
      params[:question].merge(question_group: question_group)
    end

    def update_params
      params[:question].merge(question: find_question!)
    end

    def index_location
      rapidfire.question_group_questions_url(question_group)
    end
  end
end
