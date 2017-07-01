module Rapidfire
  module Generators
    class AfterSurveyContentMigrationGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(dir)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def copy_migrations
        migration_template "migrations/add_after_survey_content_to_survey.rb", "db/migrate/add_after_survey_content_to_survey.rapidfire.rb"
      end

    end
  end
end
