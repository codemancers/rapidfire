module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    def new
      find_survey!
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      find_survey!
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        redirect_to after_answer_path_for
      else
        render :new
      end
    end

    def edit
      find_survey!
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def update
      find_survey!
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

    # Override path to redirect after answer the survey
    # Write:
    #   # my_app/app/decorators/controllers/rapidfire/answer_groups_controller_decorator.rb
    #   Rapidfire::AnswerGroupsController.class_eval do
    #     def after_answer_path_for
    #       main_app.root_path
    #     end
    #   end
    def after_answer_path_for
      surveys_path
    end

    def rapidfire_current_scoped
      send 'current_'+scoped.to_s
    end
  end
end
