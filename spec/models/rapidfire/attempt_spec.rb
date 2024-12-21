require "spec_helper"

describe Rapidfire::Attempt do
  describe "Associations" do
    it { is_expected.to belong_to(:survey) }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:answers) }
  end
end
