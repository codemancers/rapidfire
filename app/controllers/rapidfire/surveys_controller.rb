module Rapidfire
  class SurveysController < Rapidfire::ApplicationController
    before_action :authenticate_administrator!, except: :index

    def index
      @surveys = Rapidfire::Survey.all
      @surveys = @surveys.page(params[:page]) if defined?(Kaminari)
      @surveys
    end

    def new
      @survey = Rapidfire::Survey.new
    end

    def create
      source_survey = nil
      if params[:copy_survey_id]
        source_survey = Rapidfire::Survey.find(params[:copy_survey_id])
        params[:survey] = source_survey.attributes.except(*%w(created_at updated_at id))
        params[:survey][:name] = "Copy of #{params[:survey][:name]}"
      end
      @survey = Rapidfire::Survey.new(survey_params)

      if source_survey
        source_survey.questions.each do |q|
          @survey.questions << q.dup
        end
      end

      if @survey.save
        respond_to do |format|
          format.html { redirect_to surveys_path }
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
      @survey = Rapidfire::Survey.find(params[:id])
    end

    def update
      @survey = Rapidfire::Survey.find(params[:id])
      if @survey.update(survey_params)
        respond_to do |format|
          format.html { redirect_to surveys_path }
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
      @survey = Rapidfire::Survey.find(params[:id])
      @survey.destroy

      respond_to do |format|
        format.html { redirect_to surveys_path }
        format.js
      end
    end

    def results
      params[:filter] ||= {}
      @survey = Rapidfire::Survey.find(params[:id])
      @survey_results =
        SurveyResults.new(survey: @survey).extract(filter_params)

      respond_to do |format|
        format.json { render json: @survey_results, root: false }
        format.html
        format.js
        format.csv { send_data(@survey.results_to_csv(filter_params)) }
      end
    end

    private

    def survey_params
      params.require(:survey).permit(:name, :introduction, :after_survey_content, :active)
    end

    def filter_params
      params[:filter].permit({ question_ids: [], options: []})
    end
  end
end
