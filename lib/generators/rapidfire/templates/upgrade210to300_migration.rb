class RapidfireUpgrade210to300 < ActiveRecord::Migration
  def up
    # 5 migrations squashed into 1. aim of this migration is to rename
    # question_groups to surveys and answer_groups to attempts

    rename_column :rapidfire_questions, :question_group_id, :survey_id

    # dropping and adding index here, otherwise im getting index name length
    # too long error
    #
    # Index name 'temp_index_altered_rapidfire_answer_groups_on_user_id_and_user_type'
    #  on table 'altered_rapidfire_answer_groups' is too long;
    remove_index :rapidfire_answer_groups, [:user_id, :user_type]
    rename_column :rapidfire_answer_groups, :question_group_id, :survey_id
    add_index :rapidfire_answer_groups, [:user_id, :user_type]

    rename_table :rapidfire_question_groups, :rapidfire_surveys

    rename_column :rapidfire_answers, :answer_group_id, :attempt_id
    rename_table :rapidfire_answer_groups, :rapidfire_attempts
  end

  def down
    rename_table :rapidfire_attempts, :rapidfire_answer_groups
    rename_column :rapidfire_answers, :attempt_id, :answer_group_id

    rename_table :rapidfire_surveys, :rapidfire_question_groups

    # dropping and adding index here, otherwise im getting index name length
    # too long error
    #
    # Index name 'temp_index_altered_rapidfire_answer_groups_on_user_id_and_user_type'
    #  on table 'altered_rapidfire_answer_groups' is too long;
    remove_index :rapidfire_answer_groups, [:user_id, :user_type]
    rename_column :rapidfire_answer_groups, :survey_id, :question_group_id
    add_index :rapidfire_answer_groups, [:user_id, :user_type]

    rename_column :rapidfire_questions, :survey_id, :question_group_id
  end
end
