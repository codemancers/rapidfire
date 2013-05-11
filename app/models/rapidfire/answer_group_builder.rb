module Rapidfire
  class AnswerGroupBuilder
    extend  ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Conversion
    def persisted?; false end

    attr_accessor :question_group, :questions, :answers, :params

    def initialize(question_group, params = {})
      @question_group, @params = question_group, params
      build_answer_group
    end

    def build_answer_group
      @answer_group = AnswerGroup.new(:question_group => question_group)
      @answers = @question_group.questions.collect do |question|
        @answer_group.answers.build(question_id: question.id)
      end
    end

    def save(options = {})
      params.each do |question_id, answer_attributes|
        text = answer_attributes[:answer_text]
        if answer = @answer_group.answers.find { |a| a.question_id.to_s == question_id.to_s }
          answer.answer_text = text.is_a?(Array) ? text.join(',') : text
        end
      end

      @answer_group.save!(options)
    rescue
      # repopulate answers here in case of failure as they are not getting updated
      @answers = @questions.collect do |question|
        @answer_group.answers.find { |a| a.question_id == question.id }
      end
      false
    end
  end
end
