module Rapidfire
  class Attempt < ApplicationRecord
    belongs_to :survey
    has_many :answers, inverse_of: :attempt, autosave: true

    belongs_to :user, polymorphic: true, optional: true
  end
end
