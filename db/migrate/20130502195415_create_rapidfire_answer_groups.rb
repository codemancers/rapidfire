class CreateRapidfireAnswerGroups < ActiveRecord::Migration
  def change
    create_table :rapidfire_answer_groups do |t|
      t.references :survey
      t.references :user, polymorphic: true

      t.timestamps
    end
    add_index :rapidfire_answer_groups, :survey_id
    add_index :rapidfire_answer_groups, [:user_id, :user_type]
  end
end
