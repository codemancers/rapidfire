FactoryGirl.define do
  factory :attempt, :class => "Rapidfire::Attempt" do
    survey  { FactoryGirl.create(:survey) }
  end
end
