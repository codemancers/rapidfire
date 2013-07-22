module Rapidfire
  class QuestionGroupsController < Rapidfire::ApplicationController
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
      @question_group = QuestionGroup.new(question_group_params)
      @question_group.save

      respond_with(@question_group, location: rapidfire.question_groups_url)
    end

    def destroy
      @question_group = QuestionGroup.find(params[:id])
      @question_group.destroy

      respond_with(@question_group)
    end

    private
    def question_group_params
      if Rails::VERSION::MAJOR == 4
        params.require(:question_group).permit(:name)
      else
        params[:question_group]
      end
    end
  end
end
