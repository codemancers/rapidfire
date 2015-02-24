module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!

    before_filter :find_survey!
    before_filter :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @survey.questions
    end

    def new
      @question_form = QuestionForm.new(:survey => @survey)
    end

    def create
      form_params = params[:question].merge(:survey => @survey)
      @question_form = QuestionForm.new(form_params)
      @question_form.save

      if @question_form.errors.empty?
        respond_to do |format|
          format.html { redirect_to index_location }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.js
        end
      end
    end

    def edit
      @question_form = QuestionForm.new(:question => @question)
    end

    def update
      form_params = params[:question].merge(:question => @question)
      @question_form = QuestionForm.new(form_params)
      @question_form.save

      if @question_form.errors.empty?
        respond_to do |format|
          format.html { redirect_to index_location }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.js
        end
      end
    end

    def destroy
      @question.destroy
      respond_to do |format|
        format.html { redirect_to index_location }
        format.js
      end
    end

    private

    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end

    def find_question!
      @question = @survey.questions.find(params[:id])
    end

    def index_location
      rapidfire.survey_questions_url(@survey)
    end
  end
end
