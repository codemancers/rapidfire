class InstallGenerator < ActiveRecord::Generators::Base
  def create_migrations
    migration_template "create_question_groups.rb", "db/migrate/create_question_groups"
    migration_template "create_questions.rb",       "db/migrate/create_questions"
    migration_template "create_answer_groups.rb",   "db/migrate/create_answer_groups"
    migration_template "create_answers.rb",         "db/migrate/create_answers"
  end
end
