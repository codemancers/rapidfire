class AddAfterSurveyContentToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_column :rapidfire_surveys, :after_survey_content, :text
  end
end
