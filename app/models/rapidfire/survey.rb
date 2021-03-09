require 'csv'
module Rapidfire
  class Survey < ActiveRecord::Base
    belongs_to :owner, :polymorphic => true
    has_many  :attempts
    has_many  :questions

    validates :name, :presence => true


    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :introduction, :after_survey_content
    end

    def results_to_csv(filter)
      CSV.generate do |csv|
        header = []
        header << "User"
        questions.each do |question|
          header << question.question_text
        end
        csv << header
        attempts.where(SurveyResults.filter(filter, 'id')).each do |attempt|
          this_attempt = []
          this_attempt << attempt.user.try(:survey_name)
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
