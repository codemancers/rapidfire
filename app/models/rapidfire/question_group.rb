module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    has_many  :questions
    validates :name, :presence => true

    if Rails.version != "4.0.0"
      attr_accessible :name
    end
  end
end
