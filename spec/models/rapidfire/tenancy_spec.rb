require 'spec_helper'

describe 'Rapidfire::Survey' do
  before do
    Rapidfire.enable_tenancy = true
    Rapidfire.tenant_class = 'Rapidfire::Attempt'

    Rapidfire::ActiveSupportHelper.clear_model('Survey')
  end

  after(:each) do
    Rapidfire.enable_tenancy = false
    Rapidfire.tenant_class = nil

    if Rapidfire.const_defined?(:Survey)
      Rapidfire::ActiveSupportHelper.clear_model('Survey')
    end
  end

  describe 'Validations' do
    subject { Rapidfire::Survey.new }

    it { is_expected.to validate_presence_of(:tenant) }
  end
end
