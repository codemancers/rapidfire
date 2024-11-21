FactoryBot.define do
  factory :answer, :class => "Rapidfire::Answer" do
    attempt  { FactoryBot.create(:attempt) }
    question      { FactoryBot.create(:q_long)       }
    answer_text   { "hello world" }
  end
end
