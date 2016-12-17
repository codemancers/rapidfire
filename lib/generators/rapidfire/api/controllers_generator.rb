# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Api
    module Generators
      class ControllersGenerator < Rails::Generators::Base
        source_root File.expand_path('../../../../../app/controllers/rapidfire', __FILE__)
        desc 'Copies default Rapidfire Api controllers to your application.'

        def copy_controllers
          directory "api", "app/controllers/rapidfire/api"
        end
      end
    end
  end
end
