module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    if Rails::VERSION::MAJOR ==  5
      before_action :find_survey!
    else
      before_filter :find_survey!
    end

    def new
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        #redirect_to after_answer_path_for
        respond_to do |format|
          format.js { render "rapidfire/attempts/success" }
          format.html { redirect_to after_answer_path_for }
        end
      else
        #render :new
        respond_to do |format|
          error_message = 'survey_incomplete_message'.cms {'Please fill the Survey.'}
          format.js {render js: "toastr.error('#{error_message}');"}
          format.html { render :new }
        end
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
