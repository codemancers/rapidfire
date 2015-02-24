class RenameQuestionGroupsToSurveys < ActiveRecord::Migration
  def change
    rename_table :rapidfire_question_groups, :rapidfire_surveys
  end
end
