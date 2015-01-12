require 'spec_helper'

describe Rapidfire::ApplicationHelper do
  describe 'Main app inline routes' do
    before { Rapidfire.config { |config| config.inline_main_app_named_routes = true } }
    after { Rapidfire.config { |config| config.inline_main_app_named_routes = false } }

    it { expect(helper).to respond_to(:main_app_route_path) }
    it { expect(helper.main_app_route_path).to eq('/foobar') }
  end
end
