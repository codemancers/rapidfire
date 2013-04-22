module Rapidfire
  module Questions
    class Date < Rapidfire::Question
      def validate_answer(answer)
        super(answer)

        if rules[:presence]
          begin  Date.parse(answer.answer_text)
          rescue ArgumentError => e
            answer.errors.add(:answer_text, :invalid)
          end
        end
      end
    end
  end
end
