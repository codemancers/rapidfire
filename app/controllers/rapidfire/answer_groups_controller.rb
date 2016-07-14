module Rapidfire
  class AnswerGroupsController < Rapidfire::ApplicationController
    before_filter :find_survey!

    def new
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
    end

    def create
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)

      if @answer_group_builder.save
        redirect_to surveys_path
      else
        render :new
      end
    end

    private
    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end

    def answer_group_params
      answer_params = { params: (params[:answer_group] || {}) }
      answer_params.merge(user: current_user, survey: @survey)
    end
  end
end
