FactoryGirl.define do
  factory :survey, :class => "Rapidfire::Survey" do
    name  "Survey"
    introduction "Please answer all the questions in this survey."
  end
end
