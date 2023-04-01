if Rails::VERSION::MAJOR >= 5
  version = [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join('.').to_f
  base = ActiveRecord::Migration[version]
else
  base = ActiveRecord::Migration
end

class AddOwnerToSurvey < base
  def change
    add_column :rapidfire_surveys, :owner_id, :integer
    add_column :rapidfire_surveys, :owner_type, :string
  end
end
