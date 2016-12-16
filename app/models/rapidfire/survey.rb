module Rapidfire
  class Survey < ActiveRecord::Base
    has_many  :questions
    accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true
    belongs_to :company
    validates :name, :presence => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :introduction
    end
  end
end
