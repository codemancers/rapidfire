if Rails::VERSION::MAJOR >= 5
  version = [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join('.').to_f
  base = ActiveRecord::Migration[version]
else
  base = ActiveRecord::Migration
end

class AddAfterSurveyContentToSurvey < base
  def change
    add_column :rapidfire_surveys, :after_survey_content, :text
  end
end
