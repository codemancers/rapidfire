class AddOwnerToSurvey < ActiveRecord::Migration
  def change
    add_column :rapidfire_surveys, :owner_id, :integer
    add_column :rapidfire_surveys, :owner_type, :string
  end
end
