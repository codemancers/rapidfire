FactoryGirl.define do
  factory :survey, :class => "Rapidfire::Survey" do
    sequence :name do |n|
      "Survey #{n}"
    end
    introduction "Please answer all the questions in this survey."
  end
end
