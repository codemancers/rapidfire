namespace :rapidfire do
  namespace :upgrade do
    namespace :migrations do
      desc "Renaming rapidfire_answer_groups to rapidfire_attempts and rapidfire_question_groups to surveys"
      task from210to300: :environment do
        `rails generate rapidfire:upgrade_migration`
      end

      desc "Adds a field to show the user after they take a survey"
      task after_survey_page: :environment do
        `rails generate rapidfire:after_survey_content_migration`
      end
    end
  end
end
