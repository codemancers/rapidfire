class RenameQuestionGroupToSurveyInRapidfireQuestions < ActiveRecord::Migration
  def change
    rename_column :rapidfire_questions, :question_group_id, :survey_id
  end
end
