class RenameQuestionGroupToSurveyInRapidfireAnswerGroups < ActiveRecord::Migration
  def change
    # dropping and adding index here, otherwise im getting index name length
    # too long error
    #
    # Index name 'temp_index_altered_rapidfire_answer_groups_on_user_id_and_user_type'
    #  on table 'altered_rapidfire_answer_groups' is too long;

    remove_index :rapidfire_answer_groups, [:user_id, :user_type]

    rename_column :rapidfire_answer_groups, :question_group_id, :survey_id

    add_index :rapidfire_answer_groups, [:user_id, :user_type]
  end
end
