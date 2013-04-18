class CreateQuestions < ActiveRecord::Migration
  def change
    create_table(:questions) do |t|
      t.references :question_group
      t.integer    :position, :default => 10000
      t.text  :answer_options
      t.text  :validation_rules

      t.timestamps
    end
  end
end
