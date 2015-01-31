module Rapidfire
  class QuestionGroupsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!, except: :index

    def index
      @question_groups = QuestionGroup.all
    end

    def new
      @question_group = QuestionGroup.new
    end

    def create
      @question_group = QuestionGroup.new(question_group_params)
      @question_group.save
    end

    def destroy
      @question_group = QuestionGroup.find(params[:id])
      @question_group.destroy
    end

    def results
      @question_group = QuestionGroup.find(params[:id])
      @question_group_results =
        QuestionGroupResults.new(question_group: @question_group).extract

      respond_to do |format|
        format.json { @question_group_results.to_json }
      end
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
