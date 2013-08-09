module Rapidfire
  class QuestionGroupResults
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
          case question
          when Rapidfire::Questions::Select, Rapidfire::Questions::Radio,
            Rapidfire::Questions::Checkbox
            answers = question.answers.map(&:answer_text).map { |text| text.split(',') }.flatten
            answers.inject(Hash.new(0)) { |total, e| total[e] += 1; total }

          when Rapidfire::Questions::Short, Rapidfire::Questions::Date,
            Rapidfire::Questions::Long, Rapidfire::Questions::Numeric
            question.answers.pluck(:answer_text)
          end

        QuestionResult.new(question, results)
      end
    end
  end
end
