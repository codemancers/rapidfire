class RapidfireDependencyTables < ActiveRecord::Migration
  def up
    # creates a table which stores dependencies for a question. at present
    # only questions which have a collection can be added as dependents

    create_table :rapidfire_question_dependencies do |t|
      t.references :dependent_on, index: true
      t.references :question, index: true
      t.text :dependent_answer_options

      t.timestamps
    end
  end


  def down
    drop_table :rapidfire_question_dependencies
  end
end
