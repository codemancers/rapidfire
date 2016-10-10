namespace :rename do
  desc "Renaming rapidfire_answer_groups to rapidfire_attempts and rapidfire_question_groups to surveys"
  task tables_answer_groups_and_question_groups: :environment do
   ActiveRecord::Migration.rename_table(:rapidfire_answer_groups, :rapidfire_attempts)
   ActiveRecord::Migration.rename_table(:rapidfire_question_groups, :rapidfire_surveys)
  end
end
