require 'spec_helper'

describe Rapidfire::AnswerGroup do
  describe "Associations" do
    it { should belong_to(:question_group) }
  end
end
