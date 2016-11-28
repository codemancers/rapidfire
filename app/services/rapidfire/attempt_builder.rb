module Rapidfire
  class AttemptBuilder < Rapidfire::BaseService
    attr_accessor :user, :survey, :questions, :answers, :params, :attempt_id

    def initialize(params = {})
      super(params)
      build_attempt(params[:attempt_id])
    end

    def to_model
      @attempt
    end

    def save!(options = {})
      params.each do |question_id, answer_attributes|
        if answer = @attempt.answers.find { |a| a.question_id.to_s == question_id.to_s }
          text = answer_attributes[:answer_text]

          # in case of checkboxes, values are submitted as an array of
          # strings. we will store answers as one big string separated
          # by delimiter.
          answer.answer_text =
            if text.is_a?(Array)
              stripped_answers = strip_checkbox_answers(text)
              stripped_answers.join(Rapidfire.answers_delimiter)
            else
              text
            end
        end
      end

      @attempt.save!(options)
    end

    def save(options = {})
      save!(options)
    rescue ActiveRecord::ActiveRecordError => e
      # repopulate answers here in case of failure as they are not getting updated
      @answers = @survey.questions.collect do |question|
        @attempt.answers.find { |a| a.question_id == question.id }
      end
      false
    end

    private
    def build_attempt(attempt_id)
      if attempt_id.present?
        @attempt = Attempt.find(attempt_id)
        self.answers = @attempt.answers
        self.user = @attempt.user
        self.survey = @attempt.survey
        self.questions = @survey.questions
      else
        @attempt = Attempt.new(user: user, survey: survey)
        @answers = @survey.questions.collect do |question|
          @attempt.answers.build(question_id: question.id)
        end
      end
    end

    def strip_checkbox_answers(text)
      text.reject(&:blank?).reject { |t| t == "0" }
    end
  end
end
