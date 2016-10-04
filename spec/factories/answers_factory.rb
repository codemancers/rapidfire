FactoryGirl.define do
  factory :answer, :class => "Rapidfire::Answer" do
    attempt  { FactoryGirl.create(:attempt) }
    question      { FactoryGirl.create(:q_long)       }
    answer_text   "hello world"
  end
end
