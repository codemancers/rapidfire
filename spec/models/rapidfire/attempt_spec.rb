require 'spec_helper'

describe Rapidfire::Attempt do
  describe "Associations" do
    it { is_expected.to belong_to(:survey) }
    if Rails::VERSION::MAJOR >= 5
      it { is_expected.to belong_to(:user).optional }
    else
      it { is_expected.to belong_to(:user) }
    end
    it { is_expected.to have_many(:answers) }
  end
end
