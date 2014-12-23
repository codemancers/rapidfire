module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!
    respond_to :html, :js

    before_filter :find_question_group!
    before_filter :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @question_group.questions
      respond_with(@questions)
    end

    def new
      @question = QuestionForm.new(:question_group => @question_group)
      respond_with(@question)
    end

    def create
      form_params = params[:question].merge(:question_group => @question_group)
      @question = QuestionForm.new(form_params)
      if !@question.question.position
        lastq=Question.where(:question_group_id => @question_group.id).order("position").last
        if lastq && lastq.position
          @question.question.position=lastq.position+1
        else
          @question.question.position=1
        end
      end
      @question.save

      respond_with(@question, location: index_location)
    end

    def edit
      @question = QuestionForm.new(:question => @question)
      respond_with(@question)
    end

    def update
      form_params = params[:question].merge(:question => @question)
      @question = QuestionForm.new(form_params)
      @question.save

      respond_with(@question, location: index_location)
    end

    def destroy
      @question.destroy
      respond_with(@question, location: index_location)
    end

    def move
      @question = @question_group.questions.find(params[:question_id])
      lastp=@question.position
      startp=params[:position].to_i
      set=Question.where(:question_group_id => @question_group.id).where("position >= ?",startp).where("position < ?",lastp)
      #can be a big load!
      set.each do |q|
        if q.id
          mquestion=Question.find(q)
          mquestion.position=mquestion.position+1
          mquestion.save
        end
      end
      @question.position=startp
      @question.save

      redirect_to index_location
    end

    private
    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def find_question!
      @question = @question_group.questions.find(params[:id])
    end

    def index_location
      rapidfire.question_group_questions_url(@question_group)
    end
  end
end
