module Rapidfire
  class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :attempt, inverse_of: :answers

    validates :question, :attempt, presence: true
    validate  :verify_answer_text, if: :question.present?

    if Rails::VERSION::MAJOR == 3
      attr_accessor :question_id, :attempt, :answer_text
    end

    private
    def verify_answer_text
      question.validate_answer(self)
    end
  end
end
