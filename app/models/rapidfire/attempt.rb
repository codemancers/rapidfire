module Rapidfire
  class Attempt < ActiveRecord::Base
    belongs_to :survey

    if Rails::VERSION::MAJOR >= 5
      belongs_to :user, polymorphic: true, optional: true
    else
      belongs_to :user, polymorphic: true
    end

    has_many   :answers, inverse_of: :attempt, autosave: true
  end
end
