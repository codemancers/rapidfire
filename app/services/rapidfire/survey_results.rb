module Rapidfire
  class SurveyResults < Rapidfire::BaseService
    attr_accessor :survey

    # Helps in serializing results for each question
    class QuestionResult < Rapidfire::BaseService
      include ActiveModel::Serialization

      attr_accessor :question, :results

      def active_model_serializer
        Rapidfire::QuestionResultSerializer
      end
    end

    # extracts question along with results
    # each entry will have the following:
    # 1. question type and question id
    # 2. question text
    # 3. if aggregatable, return each option with value
    # 4. else return an array of all the answers given
    def extract
      @survey.questions.collect do |question|
        results =
          case question
          when Rapidfire::Questions::Select, Rapidfire::Questions::Radio,
            Rapidfire::Questions::Checkbox
            answers = question.answers.map(&:answer_text).map do |text|
              text.to_s.split(Rapidfire.answers_delimiter)
            end.flatten

            answers.inject(Hash.new(0)) { |total, e| total[e] += 1; total }
          when Rapidfire::Questions::Short, Rapidfire::Questions::Date,
            Rapidfire::Questions::Long, Rapidfire::Questions::Numeric
            question.answers.pluck(:answer_text)
          end

        QuestionResult.new(question: question, results: results)
      end
    end
  end
end
