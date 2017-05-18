module Rapidfire
  class Attempt < ActiveRecord::Base
    belongs_to :survey
    belongs_to :user, polymorphic: true
    has_many   :answers, inverse_of: :attempt, autosave: true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :user
    else
      attr_accessor :survey, :user
    end
  end
end
