FactoryGirl.define do
  factory :survey, :class => "Rapidfire::Survey" do
    name  "Test Survey"
    introduction "Please answer all the questions in this survey."
    owner  { FactoryGirl.create(:user) }
  end
end
