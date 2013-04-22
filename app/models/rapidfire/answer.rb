module Rapidfire
  class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :answer_group

    validate :verify_answer_text
    attr_accessible :answer_text, :question_id

    private
    def verify_answer_text
      question.validate_answer(self)
    end
  end
end
