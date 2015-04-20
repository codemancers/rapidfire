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
      :answer_greater_than_or_equal_to, :answer_less_than_or_equal_to,
      :dependent_on_id, :dependent_answer_options

    validates :type, presence: true, inclusion: { in: QUESTION_TYPES.values }
    validates :question_text, presence: true
    validates :answer_options, presence: true, if: :collection_question?
    validates :dependent_answer_options, presence: true,
      if: :is_dependency_specified?
    validate  :dependeny_belongs_to_survey, if: :is_dependency_specified?

    def initialize(survey)
      self.survey = survey
    end

    def create
      return false unless valid?

      capture_errors do
        self.question = type.constantize.create!(to_question_params)
        create_question_dependency!

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

      if question.question_dependency
        self.dependent_on_id = question.question_dependency.dependent_on_id
        self.dependent_answer_options =
          question.question_dependency.dependent_answer_options
      end

      self
    end

    def update
      return false unless valid?

      capture_errors do
        question.update_attributes!(to_question_params)
        update_question_dependency!

        true
      end
    end

    def dependent_questions
      survey.questions.select(&:collection_select?)
    end


    def is_dependency_specified?
      dependent_on_id.present? && dependent_on_id != "0"
    end

    private

    def collection_question?
      QUESTION_TYPES.slice("Checkbox", "Radio", "Select")
        .values
        .include?(type)
    end

    def dependeny_belongs_to_survey
      is_collection_depenency = survey.questions
        .select(&:collection_select?)
        .map { |q| q.id.to_s }
        .include?(dependent_on_id)

      if is_collection_depenency
        if question && question.id.to_s == dependent_on_id
          errors.add(:dependent_on_id, :invalid)
        end
      else
        errors.add(:dependent_on_id, :invalid)
      end
    end

    def create_question_dependency!
      if is_dependency_specified?
        question.create_question_dependency!(dependency_params)
      end
    end

    def update_question_dependency!
      dependency = question.question_dependency

      if dependency
        if is_dependency_specified?
          dependency.update_attributes!(dependency_params)
        else
          dependency.destroy!
        end
      else
        create_question_dependency!
      end
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

    def dependency_params
      {
        dependent_answer_options: dependent_answer_options,
        dependent_on_id: dependent_on_id
      }
    end
  end
end
