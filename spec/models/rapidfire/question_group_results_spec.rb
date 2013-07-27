require 'spec_helper'

describe Rapidfire::QuestionGroupResults do
  let(:question_group) { FactoryGirl.create(:question_group) }

  describe '#extract' do
    before do
      create_questions
      create_answers
      @question_group_results = Rapidfire::QuestionGroupResults.new(question_group)
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

  def create_questions
    @question_checkbox = FactoryGirl.create(:q_checkbox, :question_group => question_group)
    @question_date = FactoryGirl.create(:q_date, :question_group => question_group)
    @question_long = FactoryGirl.create(:q_long, :question_group => question_group)
    @question_numeric = FactoryGirl.create(:q_numeric, :question_group => question_group)
    @question_radio = FactoryGirl.create(:q_radio, :question_group => question_group)
    @question_select = FactoryGirl.create(:q_select, :question_group => question_group)
    @question_short = FactoryGirl.create(:q_short, :question_group => question_group)
  end

  def create_answers
    FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => 'hindi')
    FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => 'hindi,telugu')
    FactoryGirl.create(:answer, :question => @question_checkbox, :answer_text => 'hindi,kannada')

    FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'mac')
    FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'mac')
    FactoryGirl.create(:answer, :question => @question_select, :answer_text => 'windows')

    FactoryGirl.create(:answer, :question => @question_radio, :answer_text => 'male')
    FactoryGirl.create(:answer, :question => @question_radio, :answer_text => 'female')

    3.times do
      FactoryGirl.create(:answer, :question => @question_date, :answer_text => Date.today.to_s)
      FactoryGirl.create(:answer, :question => @question_long, :answer_text => 'really long answer')
      FactoryGirl.create(:answer, :question => @question_numeric, :answer_text => 999)
      FactoryGirl.create(:answer, :question => @question_short, :answer_text => 'short answer')
    end
  end
end
