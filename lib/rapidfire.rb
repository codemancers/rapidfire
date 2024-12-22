require "rapidfire/engine"

module Rapidfire
  class AccessDenied < StandardError
  end

  # configuration which will be used as delimiter in case answers are bunch
  # of collection values. This is the default delimiter which is used by
  # all the browsers.
  mattr_accessor :answers_delimiter
  self.answers_delimiter = "\r\n"

  # configuration for setting the layout
  mattr_accessor :layout

  #configuration for adding custom question types
  mattr_accessor :custom_question_types
  self.custom_question_types = []

  def self.config
    yield(self)
  end
end
