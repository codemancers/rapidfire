module Rapidfire
  module Questions
    class Numeric < Rapidfire::Question
      def validate_answer(answer)
        super(answer)

        if rules[:presence]
          validation_rules = rules.slice(:greater_than_or_equal_to, :less_than_or_equal_to)
          validation_rules.each { |k, v| validation_rules[k] = v.to_i }
          answer.validates_numericality_of :answer_text, validation_rules
        end
      end
    end
  end
end
