class AddTenantToQuestionGroups < ActiveRecord::Migration
  def change
    add_reference :rapidfire_question_groups, :tenant, polymorphic: true, index: true
  end
end
