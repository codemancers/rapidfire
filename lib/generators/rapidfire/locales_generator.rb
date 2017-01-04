# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Generators
    class LocalesGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../config/locales', __FILE__)
      desc 'Copies default Rapidfire locales to your application.'

      def copy_locales
        directory ".", "config/locales"
      end

    end
  end
end
