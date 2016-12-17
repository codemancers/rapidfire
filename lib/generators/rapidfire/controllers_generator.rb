# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/controllers', __FILE__)
      desc 'Copies default Rapidfire controllers to your application.'

      def copy_controllers
        directory "rapidfire", "app/controllers/rapidfire"
      end
    end
  end
end
