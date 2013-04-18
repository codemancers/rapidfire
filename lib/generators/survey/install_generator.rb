require 'rails/generators/active_record'

module Survey
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)

      def create_migrations
        migration_template "create_question_groups.rb", "db/migrate/create_question_groups"
        migration_template "create_questions.rb",       "db/migrate/create_questions"
        migration_template "create_answer_groups.rb",   "db/migrate/create_answer_groups"
        migration_template "create_answers.rb",         "db/migrate/create_answers"
      end

      # copied the following parts from active record
      private
      # Set the current directory as base for the inherited generators.
      def self.base_root
        File.dirname(__FILE__)
      end

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
    end
  end
end
