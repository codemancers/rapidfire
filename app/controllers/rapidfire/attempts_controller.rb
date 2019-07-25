module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    before_action :find_survey!

    def show
      @attempt = @survey.attempts.find_by(attempt_params_for_find)
    end

    def new
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        redirect_to after_answer_path_for
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
        redirect_to after_answer_path_for
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

    def attempt_params_for_find
      these_params = attempt_params
      these_params[:id] = these_params.delete(:attempt_id)
      these_params
    end

    # Override path to redirect after answer the survey
    # Write:
    #   # my_app/app/decorators/controllers/rapidfire/attempts_controller_decorator.rb
    #   Rapidfire::AttemptsController.class_eval do
    #     def after_answer_path_for
    #       main_app.root_path
    #     end
    #   end
    def after_answer_path_for
      if @survey.after_survey_content.present?
        survey_attempt_path(@survey, @attempt_builder.to_model)
      else
        surveys_path
      end
    end

    def rapidfire_current_scoped
      send 'current_'+scoped.to_s
    end
  end
end
