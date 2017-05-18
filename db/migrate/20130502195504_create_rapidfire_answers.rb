class CreateRapidfireAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :rapidfire_answers do |t|
      t.references :attempt
      t.references :question
      t.text :answer_text

      t.timestamps
    end
    add_index :rapidfire_answers, :question_id
  end
end
