class RenameAnswerGroupToAttemptInRapidfireAnswers < ActiveRecord::Migration
  def change
    rename_column :rapidfire_answers, :answer_group_id, :attempt_id
  end
end
