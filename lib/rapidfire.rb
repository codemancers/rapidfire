require "rapidfire/engine"

module Rapidfire
  class AccessDenied < StandardError
  end

  # default controllers that are associated with models
  mattr_accessor :controllers
  @@controllers = {
    question_groups: "question_groups",
    questions:       "questions",
    answer_groups:   "question_groups"
  }

  def self.config
    yield(self)
  end
end
