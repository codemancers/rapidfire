module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!

    before_filter :find_survey!
    before_filter :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @survey.questions
    end

    def new
      @question_form = QuestionForm.new(@survey)
    end

    def create
      @question_form = QuestionForm.new(@survey)

      if @question_form.with_params(params[:question]).create()
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
      @question_form = QuestionForm.new(@survey).edit(@question)
    end

    def update
      @question_form = QuestionForm.new(@survey).edit(@question)

      if @question_form.with_params(params[:question]).update()
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
