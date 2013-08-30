module Rapidfire
  class AnswerGroupBuilder < Rapidfire::BaseService
    attr_accessor :user, :question_group, :questions, :answers, :params

    def initialize(params = {})
      super(params)
      build_answer_group
    end

    def to_model
      @answer_group
    end

    def save!(options = {})
      @answer_group.save!(options)
    end

    def save(options = {})
      save!(options)
    rescue Exception => e
      # repopulate answers here in case of failure as they are not getting updated
      @answers = @question_group.questions.collect do |question|
        @answer_group.answers.find { |a| a.question_id == question.id }
      end
      false
    end

    private
    def build_answer_group
      @answer_group = AnswerGroup.new(user: user, question_group: question_group)
      @answers = @question_group.questions.collect do |question|
        @answer_group.answers.build(question_id: question.id)
      end
      populate_answers_from_params
    end

    def populate_answers_from_params
      return if params.nil? || params.empty?

      params.each do |question_id, answer_attributes|
        answer = @answer_group.answers.find { |a| a.question_id.to_s == question_id.to_s }
        next unless answer

        text = answer_attributes[:answer_text]
        answer.answer_text =
          text.is_a?(Array) ? strip_checkbox_answers(text).join(',') : text
      end
    end

    def strip_checkbox_answers(text)
      text.reject(&:blank?).reject { |t| t == "0" }
    end
  end
end
