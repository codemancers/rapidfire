class RenameAnswerGroupsToAttempts < ActiveRecord::Migration
  def change
    rename_table :rapidfire_answer_groups, :rapidfire_attempts
  end
end
