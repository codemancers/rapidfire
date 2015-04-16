module Rapidfire
  class QuestionForm < Rapidfire::BaseService
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

    attr_accessor :survey, :question,
      :type, :question_text, :answer_options, :answer_presence,
      :answer_minimum_length, :answer_maximum_length,
      :answer_greater_than_or_equal_to, :answer_less_than_or_equal_to

    validates :type, presence: true, inclusion: { in: QUESTION_TYPES.values }
    validates :question_text, presence: true
    validates :answer_options, presence: true, if: :collection_question?

    def initialize(survey)
      self.survey = survey
    end

    def create
      return false unless valid?

      capture_errors do
        self.question =
          type.constantize.create!(to_question_params)
        true
      end
    end

    def edit(question)
      self.question = question
      self.type = question.type
      self.question_text   = question.question_text
      self.answer_options  = question.answer_options
      self.answer_presence = question.rules[:presence]
      self.answer_minimum_length = question.rules[:minimum]
      self.answer_maximum_length = question.rules[:maximum]
      self.answer_greater_than_or_equal_to = question.rules[:greater_than_or_equal_to]
      self.answer_less_than_or_equal_to    = question.rules[:less_than_or_equal_to]

      self
    end

    def update
      return false unless valid?

      capture_errors do
        question.update_attributes!(to_question_params)
        true
      end
    end

    private

    def collection_question?
      QUESTION_TYPES.slice("Checkbox", "Radio", "Select")
        .values
        .include?(type)
    end

    def to_question_params
      {
        :survey => survey,
        :question_text  => question_text,
        :answer_options => answer_options,
        :validation_rules => {
          :presence => answer_presence,
          :minimum  => answer_minimum_length,
          :maximum  => answer_maximum_length,
          :greater_than_or_equal_to => answer_greater_than_or_equal_to,
          :less_than_or_equal_to    => answer_less_than_or_equal_to
        }
      }
    end
  end
end
