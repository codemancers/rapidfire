class CreateAnswerGroups < ActiveRecord::Migration
  def change
    create_table(:answer_groups) do |t|
      t.references  :question_group

      t.timestamps
    end
  end
end
