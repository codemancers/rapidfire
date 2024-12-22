module Rapidfire
  class Question < ApplicationRecord
    belongs_to :survey, inverse_of: :questions
    has_many :answers
    has_many_attached :files

    default_scope { order(:position) }

    validates :survey, :question_text, presence: true
    validate :type_can_change
    serialize :validation_rules, coder: YAML

    def self.inherited(child)
      child.instance_eval do
        def model_name
          Question.model_name
        end
      end

      super
    end

    def rules
      validation_rules.present? ? validation_rules.symbolize_keys : {}
    end

    def validation_rules=(val)
      super(val.stringify_keys)
    end

    # answer will delegate its validation to question, and question
    # will inturn add validations on answer on the fly!
    def validate_answer(answer)
      if rules[:presence] == "1"
        case self
        when Rapidfire::Questions::File
          answer.validates_presence_of :file
        when Rapidfire::Questions::MultiFile
          answer.validates_presence_of :files
        else
          answer.validates_presence_of :answer_text
        end
      end

      if rules[:minimum].present? || rules[:maximum].present?
        min_max = { minimum: rules[:minimum].to_i }
        min_max[:maximum] = rules[:maximum].to_i if rules[:maximum].present?

        answer.validates_length_of :answer_text, min_max
      end
    end

    def type_can_change
      if type_changed? && answers.any?
        errors.add(:type, "cannot change after answers have been added")
      end
    end
  end
end
