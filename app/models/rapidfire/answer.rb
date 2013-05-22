module Rapidfire
  class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :answer_group

    validates :question, :answer_group, presence: true
    validate  :verify_answer_text, :if => "question.present?"

    private
    def verify_answer_text
      question.validate_answer(self)
    end
  end
end
