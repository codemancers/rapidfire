# This service is used to persist answers to database given a question group,
# user and answer params. Everytime a new set of answer group is created and
# answers are persisted.
#
# If you want existing answers to be persisted, then set the boolean variable
# `update_existing_answers` to true. This fetches existing answers and updates
# them.
module Rapidfire
  class AnswerGroupBuilder < Rapidfire::BaseService
    attr_accessor :user, :question_group, :questions, :answers, :params
    attr_accessor :answer_group, :update_existing_answers

    def initialize(params = {})
      super(params)
      fetch_or_build_answer_group
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
    def fetch_or_build_answer_group
      self.answer_group   = fetch_answer_group if update_existing_answers
      self.answer_group ||= build_answer_group

      self.answers = question_group.questions.collect do |question|
        answer_group.answers.find { |a| a.question_id == question.id } ||
          answer_group.answers.build(question_id: question.id)
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

    def fetch_answer_group
      if user
        AnswerGroup.where(user_id: user.id, user_type: user.class.to_s,
                          question_group: question_group).first
      else
        AnswerGroup.where(question_group: question_group).first
      end
    end

    def build_answer_group
      AnswerGroup.new(user: user, question_group: question_group)
    end

    def strip_checkbox_answers(text)
      text.reject(&:blank?).reject { |t| t == "0" }
    end
  end
end
