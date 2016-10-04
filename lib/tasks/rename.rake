namespace :rename do
  desc "Renaming rapidfire_answer_groups to rapidfire_attempts"
  task question_groups_to_surveys: :environment do
   ActiveRecord::Migration.rename_table(:rapidfire_answer_groups, :rapidfire_attempts)
  end
end
