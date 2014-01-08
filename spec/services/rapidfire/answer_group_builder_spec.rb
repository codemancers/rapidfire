require 'spec_helper'

describe Rapidfire::AnswerGroupBuilder do
  let(:question_group)  { FactoryGirl.create(:question_group) }
  let(:question1)  { FactoryGirl.create(:q_short, question_group: question_group) }
  let(:question2)  { FactoryGirl.create(:q_long, question_group: question_group,
                                        validation_rules: { presence: "1" }) }

  describe "Creation" do
    let(:builder)  { described_class.new(question_group: question_group) }
    before(:each)  { [question1, question2] }

    it "builds answer group with answers" do
      builder.answers.should_not be_empty
    end

    it "builds answers based on number of questions available" do
      questions = builder.answers.collect { |a| a.question }
      questions.should =~ [question1, question2]
    end

    context 'when update_existing_answers is set' do
      let(:builder) do
        described_class.new(question_group: question_group, update_existing_answers: true)
      end

      before(:each) do
        answer_group = FactoryGirl.create(:answer_group, question_group: question_group)
        FactoryGirl.create(:answer, answer_group: answer_group, question: question1, answer_text: 'small')
        FactoryGirl.create(:answer, answer_group: answer_group, question: question2, answer_text: 'long')
      end

      it 'picks up existing answers from database' do
        answer_texts = builder.answers.map(&:answer_text)
        expect(answer_texts).to match_array(['small', 'long'])
      end
    end
  end

  describe "#save" do
    let(:question_ids)  { question_group.questions.map(&:id) }
    let(:builder) do
      params = { params: answer_params }.merge(question_group: question_group)
      described_class.new(params)
    end
    let(:save_answers)  { builder.save }

    before(:each) do
      [question1, question2]
      save_answers
    end

    context "when all the answers are valid" do
      let(:answer_params) do
        {
          question1.id.to_s => { :answer_text => "short answer" },
          question2.id.to_s => { :answer_text => "long answer!" }
        }
      end

      it "returns true" do
        save_answers.should be_true
      end

      it "successfully saves answers" do
        builder.answers.each do |answer|
          answer.should be_persisted
          question_ids.should include(answer.question_id)
        end
      end
    end

    context "when some of the answers are invalid" do
      let(:answer_params) do
        {
          question1.id.to_s => { :answer_text => "short answer" },
          question2.id.to_s => { :answer_text => "" }
        }
      end

      it "returns false" do
        save_answers.should be_false
      end

      it "fails to save those answers" do
        Rapidfire::Answer.count.should == 0
      end

      context "when requested to save without validations" do
        let(:save_answers)  { builder.save(:validate => false) }

        it "returns true" do
          save_answers.should be_true
        end

        it "saves all the answers" do
          builder.answers.each do |answer|
            answer.should be_persisted
            question_ids.should include(answer.question_id)
          end
        end
      end
    end
  end
end
