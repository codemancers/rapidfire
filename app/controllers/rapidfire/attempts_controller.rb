module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    before_filter :find_survey!

    def new
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        redirect_to surveys_path
      else
        render :new
      end
    end

    def edit
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def update
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        redirect_to surveys_path
      else
        render :edit
      end
    end

    private
    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end

    def attempt_params
      answer_params = { params: (params[:attempt] || {}) }
      answer_params.merge(user: current_user, survey: @survey, attempt_id: params[:id])
    end
  end
end
