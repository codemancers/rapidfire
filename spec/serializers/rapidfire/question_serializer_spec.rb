require "spec_helper"

describe Rapidfire::QuestionSerializer do
  let(:question) do
    FactoryGirl.build_stubbed(:q_select, question_text: 'checking serialization')
  end

  let(:question_json) do
    json = described_class.new(question).to_json
    ActiveSupport::JSON.decode(json)
  end

  it 'exposes question text' do
    expect(question_json["question_text"]).to eq 'checking serialization'
  end

  it 'exposes answer options' do
    expect(question_json["answer_options"]).to match_array ['mac', 'windows']
  end

  it 'exposes only 2 fields' do
    expect(question_json.size()).to eq(2)
  end
end
