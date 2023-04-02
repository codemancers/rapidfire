module Rapidfire
  class Answer < ApplicationRecord
    belongs_to :question
    belongs_to :attempt, inverse_of: :answers

    validates :question, :attempt, presence: true
    validate  :verify_answer_text

    if "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}" >= "5.2"
      has_one_attached :file
      has_many_attached :files
    end

    private

    def verify_answer_text
      return false unless question.present?
      question.validate_answer(self)
    end
  end
end
