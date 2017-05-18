module Rapidfire
  class Survey < ActiveRecord::Base
    has_many  :questions
    validates :name, :presence => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :introduction
    else
      attr_accessor :name, :introduction
    end
  end
end
