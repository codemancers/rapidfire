class RenameAnswerGroupsAndQuestionGroups < ActiveRecord::Migration
  def change
    rename_table :rapidfire_answer_groups, :rapidfire_attempts
    rename_table :rapidfire_question_groups, :rapidfire_surveys
    rename_column :rapidfire_answers, :answer_group_id, :attempt_id
    rename_column :rapidfire_attempts, :question_group_id, :survey_id
    rename_column :rapidfire_questions, :question_group_id, :survey_id
  end
end
