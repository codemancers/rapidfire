module Rapidfire
  class SurveysController < Rapidfire::ApplicationController
    if Rails::VERSION::MAJOR >= 5
      before_action :authenticate_administrator!, except: :index
    else
      before_filter :authenticate_administrator!, except: :index
    end

    def index
      @surveys = owner_surveys_scope.all
      @surveys = @surveys.page(params[:page]) if defined?(Kaminari)
      @surveys
    end

    def new
      @survey = owner_surveys_scope.new
    end

    def create
      @survey = owner_surveys_scope.new(survey_params)
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
      @survey = owner_surveys_scope.find(params[:id])
    end

    def update
      @survey = owner_surveys_scope.find(params[:id])
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
      @survey = owner_surveys_scope.find(params[:id])
      @survey.destroy

      respond_to do |format|
        format.html { redirect_to surveys_path }
        format.js
      end
    end

    def results
      params[:filter] ||= {}
      @survey = owner_surveys_scope.find(params[:id])
      @survey_results =
        SurveyResults.new(survey: @survey).extract(params[:filter].permit({ question_ids: [], options: []}))

      respond_to do |format|
        format.json { render json: @survey_results, root: false }
        format.html
        format.js
      end
    end

    private

    def survey_params
      if Rails::VERSION::MAJOR >= 4
        params.require(:survey).permit(:name, :introduction, :after_survey_content)
      else
        params[:survey]
      end
    end
  end
end
