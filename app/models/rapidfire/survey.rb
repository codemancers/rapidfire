require 'csv'
module Rapidfire
  class Survey < ActiveRecord::Base
    belongs_to :owner, :polymorphic => true
    has_many  :questions
    has_many :attempts

    validates :name, :presence => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :introduction, :after_survey_content
    end

    def results_to_csv(filter)
      CSV.generate do |csv|
        header = []
        questions.each do |question|
          header << question.question_text
        end
        csv << header
        attempts.where(SurveyResults.filter(filter, 'id')).each do |attempt|
          this_attempt = []
          questions.each do |question|
            answer = attempt.answers.detect{|a| a.question_id == question.id }.try(:answer_text)
            this_attempt << answer
          end
          csv << this_attempt
        end
      end
    end
  end
end
