module Rapidfire
  module Generators
    class UpgradeMigrationGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(dir)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def copy_migrations
        migration_template "migrations/rename_answer_groups_and_question_groups.rb", "db/migrate/rename_answer_groups_and_question_groups.rb"
      end

    end
  end
end
