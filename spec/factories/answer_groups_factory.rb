FactoryGirl.define do
  factory :answer_group, :class => "Rapidfire::AnswerGroup" do
    survey  { FactoryGirl.create(:survey) }
  end
end
