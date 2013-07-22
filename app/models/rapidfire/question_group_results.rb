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
    # 3. if question type is aggregetable, each option with value
    # 4. else an array of all the answers
    def extract
    end
  end
end
