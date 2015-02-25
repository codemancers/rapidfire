require 'rails/generators'
require 'rails/generators/migration'

module Rapidfire
  class Upgrade210to300Generator < Rails::Generators::Base
    include Rails::Generators::Migration

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    # Implement the required interface for Rails::Generators::Migration.
    # taken from activerecord/lib/generators/active_record.rb
    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      if ActiveRecord::Base.timestamped_migrations
        [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
      else
        "%.3d" % next_migration_number
      end
    end

    def create_migration_file
      migration_template 'upgrade210to300_migration.rb',
        'db/migrate/rapidfire_upgrade210to300.rb'
    end
  end
end
