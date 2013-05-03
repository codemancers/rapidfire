# This migration comes from rapidfire (originally 20130502195415)
class CreateRapidfireAnswerGroups < ActiveRecord::Migration
  def change
    create_table :rapidfire_answer_groups do |t|
      t.references :question_group

      t.timestamps
    end
    add_index :rapidfire_answer_groups, :question_group_id
  end
end
