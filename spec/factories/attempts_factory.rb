FactoryBot.define do
  factory :attempt, :class => "Rapidfire::Attempt" do
    survey  { FactoryBot.create(:survey) }
  end
end
