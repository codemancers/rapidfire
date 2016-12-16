# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Generators
    class ModelsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/models', __FILE__)
      desc 'Copies default Rapidfire models to your application.'

      def copy_controllers
        directory "rapidfire", "app/models/rapidfire"
      end
    end
  end
end
