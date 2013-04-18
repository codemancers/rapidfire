class CreateAnswers < ActiveRecord::Migration
  def change
    create_table(:answers) do |t|
      t.references  :answer_group
      t.references  :question
      t.text  :answer_text

      t.timestamps
    end
  end
end
