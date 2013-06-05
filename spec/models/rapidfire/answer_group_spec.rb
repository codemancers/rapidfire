require 'spec_helper'

describe Rapidfire::AnswerGroup do
  describe "Associations" do
    it { should belong_to(:question_group) }
    it { should belong_to(:user)    }
    it { should have_many(:answers) }
  end
end
