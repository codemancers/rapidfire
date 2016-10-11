class RenameAnswerGroupsToAttempts < ActiveRecord::Migration[5.0]
  def change
    rename_table :rapidfire_answer_groups, :rapidfire_attempts
  end
end
