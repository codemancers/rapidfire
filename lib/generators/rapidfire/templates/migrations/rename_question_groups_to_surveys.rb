class RenameQuestionGroupsToSurveys < ActiveRecord::Migration[5.0]
  def change
    rename_table :rapidfire_question_groups, :rapidfire_surveys
  end
end
