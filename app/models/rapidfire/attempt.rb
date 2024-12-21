module Rapidfire
  class Attempt < ApplicationRecord
    belongs_to :survey
    has_many :answers, dependent: :destroy, inverse_of: :attempt
    belongs_to :user, polymorphic: true, optional: true
  end
end
