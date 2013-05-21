FactoryGirl.define do
  factory :question do
    question_text "Sample Question"

    factory :q_checkbox, :class => "Forem::Questions::Checkbox" do
      answer_options  "hindi\r\ntelugu\r\nkannada\r\n"
    end

    factory :q_date, :class => "Forem::Questions::Date" do
    end

    factory :q_long, :class => "Forem::Questions::Long" do
    end

    factory :q_numeric, :class => "Forem::Questions::Numeric" do
    end

    factory :q_radio, :class => "Forem::Questions::Radio" do
      answer_options  "male\r\nfemale\r\n"
    end

    factory :q_select, :class => "Forem::Questions::Select" do
      answer_options  "mac\r\nwnidows\r\n"
    end

    factory :q_short, :class => "Forem::Questions::Short" do
    end
  end
end
