module Rapidfire
  class Survey < ActiveRecord::Base
    belongs_to :owner, :polymorphic => true
    has_many  :questions
    validates :name, :presence => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :introduction
    end
  end
end
