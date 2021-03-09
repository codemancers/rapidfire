module Rapidfire
  class Attempt < ActiveRecord::Base
    belongs_to :survey
    has_many   :answers, inverse_of: :attempt, autosave: true

    if Rails::VERSION::MAJOR >= 5
      belongs_to :user, polymorphic: true, optional: true
    else
      belongs_to :user, polymorphic: true
    end
  end
end
