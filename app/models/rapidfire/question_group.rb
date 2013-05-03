module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection

    has_many  :questions
    validates :name, :presence => true
  end
end
