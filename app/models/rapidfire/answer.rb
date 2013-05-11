module Rapidfire
  class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :answer_group

    validate :verify_answer_text

    private
    def verify_answer_text
      question.validate_answer(self)
    end
  end
end
