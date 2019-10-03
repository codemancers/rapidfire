module Rapidfire
  class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :attempt, inverse_of: :answers

    validates :question, :attempt, presence: true
    validate  :verify_answer_text

    private

    def verify_answer_text
      return false unless question.present?
      question.validate_answer(self)
    end
  end
end
