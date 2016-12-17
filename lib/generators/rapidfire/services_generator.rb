# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Generators
    class ServicesGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/services', __FILE__)
      desc 'Copies default Rapidfire services to your application.'

      def copy_controllers
        directory "rapidfire", "app/services/rapidfire"
      end
    end
  end
end
