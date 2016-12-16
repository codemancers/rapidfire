module Rapidfire
  class SurveysController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!, except: :index

    def index
      @surveys = Survey.where company_id: current_company.to_param
    end

    def new
      @survey = Survey.new
    end

    def create
      @survey = Survey.new(survey_params)
      if @survey.save
        create_questions
        respond_to do |format|
          format.html { redirect_to surveys_path, notice: "Pesquisa criada com sucesso!" }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.js
        end
      end
    end

    def destroy
      @survey = Survey.find(params[:id])
      @survey.destroy
      respond_to do |format|
        format.html { redirect_to surveys_path }
        format.js
      end
    end

    def results
      @survey = Survey.find(params[:id])
      @survey_results =
        SurveyResults.new(survey: @survey).extract

      respond_to do |format|
        format.json { render json: @survey_results, root: false }
        format.html
        format.js
      end
    end

    private

    def create_questions
      _params = questions_params
      _params.each do |question|
        @question_form = QuestionForm.new(question)
        @question_form.save
      end
    end

    def survey_params
      {
        name: survey_permited_params[:name],
        company: survey_permited_params[:company]
      }
    end

    def questions_params
      _params = []
      survey_permited_params[:questions_attributes].each do  |index|
        question = survey_permited_params[:questions_attributes][index]
        question[:survey] = @survey
        question[:validation_rules] = {
          :presence => question[:answer_presence],
          :minimum  => question[:answer_minimum_length],
          :maximum  => question[:answer_maximum_length],
          :greater_than_or_equal_to => question[:answer_greater_than_or_equal_to],
          :less_than_or_equal_to    => question[:answer_less_than_or_equal_to]
        }
        _params.push({ question: question, at_survey_creation: true })
      end
      _params
    end

    def survey_permited_params
      questions_attributes = { questions_attributes: [
        :survey,
        :type,
        :question_text,
        :position,
        :answer_options,
        :answer_presence,
        :answer_minimum_length,
        :answer_maximum_length,
        :answer_greater_than_or_equal_to,
        :answer_less_than_or_equal_to
       ] }
      if Rails::VERSION::MAJOR >= 4
        params.require(:survey).permit(:name, :introduction,
                                        questions_attributes )
                               .merge(company: current_company)
      else
        params[:survey]
      end
    end
  end
end
