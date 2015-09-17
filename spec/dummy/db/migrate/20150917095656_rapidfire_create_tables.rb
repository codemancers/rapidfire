class RapidfireCreateTables < ActiveRecord::Migration
  def up
    # creates 4 tables required for storing:
    # - surveys
    # - questions
    # - attempts
    # - answers

    create_table :rapidfire_surveys do |t|
      t.references :tenant, index: true
      t.string  :name
      t.timestamps
    end

    create_table :rapidfire_questions do |t|
      t.references :survey, index: true
      t.string  :type
      t.string  :question_text
      t.integer :position
      t.text :answer_options
      t.text :validation_rules

      t.timestamps
    end

    create_table :rapidfire_attempts do |t|
      t.references :survey, index: true
      t.references :user, polymorphic: true, index: true

      t.timestamps
    end

    create_table :rapidfire_answers do |t|
      t.references :attempt, index: true
      t.references :question, index: true
      t.text :answer_text

      t.timestamps
    end
  end


  def down
    drop_table :rapidfire_answers
    drop_table :rapidfire_attempts
    drop_table :rapidfire_questions
    drop_table :rapidfire_surveys
  end
end
