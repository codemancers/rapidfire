module Rapidfire
  class QuestionProxy
    extend  ActiveModel::Naming
    include ActiveModel::Conversion

    AVAILABLE_QUESTIONS =
      [
       Rapidfire::Questions::Checkbox,
       Rapidfire::Questions::Date,
       Rapidfire::Questions::Long,
       Rapidfire::Questions::Numeric,
       Rapidfire::Questions::Radio,
       Rapidfire::Questions::Select,
       Rapidfire::Questions::Short,
      ]

    QUESTION_TYPES = AVAILABLE_QUESTIONS.inject({}) do |result, question|
      question_name = question.to_s.split("::").last
      result[question_name] = question.to_s
      result
    end

    attr_accessor :question_group, :question,
      :type, :question_text, :answer_options, :answer_presence,
      :answer_minimum_length, :answer_maximum_length,
      :answer_greater_than_or_equal, :answer_less_than_or_equal

    delegate :valid?, :errors, :id, :to => :question

    def persisted?
      false
    end

    def to_model
      question
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end

      if question
        from_question_to_attributes(question)
      else
        @question = question_group.questions.new
      end
    end

    def save
      @question.new_record? ? create_question : update_question
    end

    def create_question
      klass = nil
      if QUESTION_TYPES.values.include?(type)
        klass = type.constantize
      else
        errors.add(:type, :invalid)
        return false
      end

      @question = klass.new(to_question_params)
      @question.save
    end

    def update_question
      @question.update_attributes(to_question_params)
    end

    def to_question_params
      {
        :question_text  => question_text,
        :answer_options => answer_options,
        :validation_rules => {
          :presence => answer_presence,
          :minimum  => answer_minimum_length,
          :maximum  => answer_maximum_length,
          :greater_than_or_equal_to => answer_greater_than_or_equal,
          :less_than_or_equal_to    => answer_less_than_or_equal
        }
      }
    end

    def from_question_to_attributes(question)
      type = question.type
      question_text   = question.question_text
      answer_options  = question.answer_options
      answer_presence = question.rules[:presence]
      answer_minimum_length = question.rules[:minimum]
      answer_maximum_length = question.rules[:maximum]
      answer_greater_than_or_equal = question.rules[:greater_than_or_equal_to]
      answer_less_than_or_equal    = question.rules[:less_than_or_equal_to]
    end
  end
end
