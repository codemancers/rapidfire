# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Generators
    class HelpersGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/helpers', __FILE__)
      desc 'Copies default Rapidfire helpers to your application.'

      def copy_controllers
        directory "rapidfire", "app/helpers/rapidfire"
      end
    end
  end
end
