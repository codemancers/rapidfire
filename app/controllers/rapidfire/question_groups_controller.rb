module Rapidfire
  class QuestionGroupsController < ApplicationController
    before_filter :authenticate_administrator!, except: :index
    respond_to :html, :js

    def index
      @question_groups = QuestionGroup.all
      respond_with(@question_groups)
    end

    def new
      @question_group = QuestionGroup.new
      respond_with(@question_group)
    end

    def create
      @question_group = QuestionGroup.new(params[:question_group])
      @question_group.save

      respond_with(@question_group)
    end

    def destroy
      @question_group = QuestionGroup.find(params[:id])
      @question_group.destroy

      respond_with(@question_group)
    end
  end
end
