class AddAfterSurveyContentToSurvey < ActiveRecord::Migration
  def change
    add_column :rapidfire_surveys, :after_survey_content, :text
  end
end
