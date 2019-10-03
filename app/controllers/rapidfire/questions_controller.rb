module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    before_action :authenticate_administrator!
    before_action :find_survey!
    before_action :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @survey.questions
    end

    def new
      @question_form = QuestionForm.new(:survey => @survey)
    end

    def create
      form_params = question_params.merge(:survey => @survey)

      save_and_redirect(form_params, :new)
    end

    def edit
      @question_form = QuestionForm.new(:question => @question)
    end

    def update
      form_params = question_params.merge(:question => @question)
      save_and_redirect(form_params, :edit)
    end

    def destroy
      @question.destroy
      respond_to do |format|
        format.html { redirect_to index_location }
        format.js
      end
    end

    private

    def save_and_redirect(params, on_error_key)
      @question_form = QuestionForm.new(params)
      @question_form.save

      if @question_form.errors.empty?
        respond_to do |format|
          format.html { redirect_to index_location }
          format.js
        end
      else
        respond_to do |format|
          format.html { render on_error_key.to_sym }
          format.js
        end
      end
    end

    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end

    def find_question!
      @question = @survey.questions.find(params[:id])
    end

    def index_location
      rapidfire.survey_questions_url(@survey)
    end

    def question_params
      params.require(:question).permit!
    end
  end
end
