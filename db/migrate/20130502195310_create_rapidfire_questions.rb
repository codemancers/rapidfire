class CreateRapidfireQuestions < ActiveRecord::Migration
  def change
    create_table :rapidfire_questions do |t|
      t.references :survey
      t.string  :type
      t.string  :question_text
      t.integer :position
      t.text :answer_options
      t.text :validation_rules

      t.timestamps
    end
    add_index :rapidfire_questions, :survey_id
  end
end
