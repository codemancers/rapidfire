class AddActiveToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_column :rapidfire_surveys, :active, :boolean, default: 1
  end
end
