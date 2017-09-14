require 'spec_helper'

describe "Surveys with pagination" do
  let!(:surveys)  { FactoryGirl.create_list(:survey, 50) }

  before do
    visit rapidfire.root_path
  end

  it "lists all surveys within page scope" do
    page_no = 1
    while surveys.present?
      surveys_per_page = surveys.shift(25)
      surveys_per_page.each do |survey|
        expect(page).to have_text(survey.name)
      end
      page_no = page_no + 1
      click_link "#{page_no}" if surveys.present?
    end
  end
end
