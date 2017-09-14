require 'spec_helper'

describe "Surveys with pagination" do
  let!(:surveys) { FactoryGirl.create_list(:survey, 50) }
  before do
    visit rapidfire.root_path
  end

  it "lists all surveys within page scope" do
    expect(page).to have_text(surveys.first.name, count: 25)
    click_link "2"
    expect(page).to have_text(surveys.first.name, count: 25)
  end
end
