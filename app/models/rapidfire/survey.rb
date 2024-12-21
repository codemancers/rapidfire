require "csv"

module Rapidfire
  class Survey < ApplicationRecord
    has_many :attempts, dependent: :destroy
    has_many :questions, dependent: :destroy
    has_many :answers, through: :attempts, dependent: :destroy

    validates :name, presence: true

    def self.csv_user_attributes=(attributes)
      @@csv_user_attributes = Array(attributes)
    end

    def self.csv_user_attributes
      @@csv_user_attributes ||= []
    end

    def results_to_csv(filter)
      CSV.generate do |csv|
        header = []
        header += Rapidfire::Survey.csv_user_attributes
        questions.each do |question|
          header << ActionView::Base.full_sanitizer.sanitize(question.question_text, tags: [], attributes: [])
        end
        header << "results updated at"
        csv << header
        attempts.where(SurveyResults.filter(filter, "id")).each do |attempt|
          this_attempt = []

          Survey.csv_user_attributes.each do |attribute|
            this_attempt << attempt.user.try(attribute)
          end

          questions.each do |question|
            answer = attempt.answers.detect { |a| a.question_id == question.id }.try(:answer_text)
            this_attempt << answer
          end
        end
      end
    end
  end
end
