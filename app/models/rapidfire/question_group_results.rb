module Rapidfire
  class QuestionGroupResults
    class Result
      def initialize(question, results)
        @question, @results = question, results
      end
      attr_accessor :question, :results
    end


    def initialize(question_group)
      @question_group = question_group
    end
    attr_accessor :question_group

    # extracts question along with results
    # each entry will have the following:
    # 1. question type and question id
    # 2. question text
    # 3. if aggregatable, return each option with value
    # 4. else return an array of all the answers given
    def extract
      @question_group.questions.collect do |question|
        results =
          case question.class
          when Rapidfire::Questions::Select, Rapidfire::Questions::Radio,
            Rapidfire::Questions::Checkbox
            question.answers.group(:answer_text).count

          when Rapidfire::Questions::Short, Rapidfire::Questions::Date,
            Rapidfire::Questions::Long, Rapidfire::Questions::Numeric
            question.answers.pluck(:answer_text)
          end

        Result.new(question, results)
      end
    end
  end
end
