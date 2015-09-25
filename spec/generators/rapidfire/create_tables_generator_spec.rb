require 'spec_helper'
require 'generators/rapidfire/create_tables_generator'
require 'rails/generators/testing/setup_and_teardown'
require 'rails/generators/testing/behaviour'


describe Rapidfire::CreateTablesGenerator do
  before do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
  end

  after do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
  end

  include Rails::Generators::Testing::SetupAndTeardown
  include Rails::Generators::Testing::Behaviour
  include FileUtils

  tests Rapidfire::CreateTablesGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  it "runs generator without errors" do
    expect { run_generator }.not_to raise_error
  end

  it "creates migration which when run migrates properly" do
    run_generator

    require Dir.glob(Rails.root.join("tmp/generators/db/migrate/*.rb")).first
    expect { RapidfireCreateTables.new.up }.not_to raise_error
  end
end
