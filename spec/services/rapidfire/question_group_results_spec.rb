require 'spec_helper'

describe Rapidfire::QuestionGroupResults do
  include Rapidfire::QuestionSpecHelper
  include Rapidfire::AnswerSpecHelper

  let(:question_group) { FactoryGirl.create(:question_group) }

  describe '#extract' do
    before do
      create_questions(question_group)
      create_answers
      @question_group_results =
        Rapidfire::QuestionGroupResults.new(question_group: question_group)
      @results = @question_group_results.extract
    end

    it 'returns checkbox answers as a hash containing options as keys and number of answers as values' do
      answers = @results.find { |result| result.question == @question_checkbox }
      answers.results['hindi'].should == 3
      answers.results['telugu'].should == 1
      answers.results['kannada'].should == 1
    end

    it 'returns "date" type answers as an array' do
      answers = @results.find { |result| result.question == @question_date }
      answers.results.should be_a(Array)
    end

    it 'returns "long" type answers as an array' do
      answers = @results.find { |result| result.question == @question_long }
      answers.results.should be_a(Array)
    end

    it 'returns "numeric" type answers as an array' do
      answers = @results.find { |result| result.question == @question_numeric }
      answers.results.should be_a(Array)
    end

    it 'returns "short" type answers as an array' do
      answers = @results.find { |result| result.question == @question_short }
      answers.results.should be_a(Array)
    end

    it 'returns "radio" type answers as a hash containing options as keys and number of answers as values' do
      answers = @results.find { |result| result.question == @question_radio }
      answers.results['male'].should == 1
      answers.results['female'].should == 1
    end

    it 'returns "select" type answers as a hash containing options as keys and number of answers as values' do
      answers = @results.find { |result| result.question == @question_select }
      answers.results['mac'].should == 2
      answers.results['windows'].should == 1
    end

    it 'returns "short" type answers as an array' do
      answers = @results.find { |result| result.question == @question_short }
      answers.results.should be_a(Array)
    end
  end

end
