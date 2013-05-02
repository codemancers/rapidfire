module Rapidfire
  class QuestionGroupsController < ApplicationController
    respond_to :html

    def index
      @question_groups = QuestionGroup.all
      respond_with(@question_groups)
    end

    def show
      @question_group = QuestionGroup.find(params[:id])
      respond_with(@question_group)
    end

    def create
      @question_group = QuestionGroup.new
      @question_group.save

      location = question_group_questions_path(@question_group)
      respond_with(@question_group, :location => location)
    end
  end
end
