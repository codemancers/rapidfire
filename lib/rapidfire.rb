require "rapidfire/engine"

module Rapidfire
  class AccessDenied < StandardError
  end

  # configuration which will be used as delimiter in case answers are bunch
  # of collection values. This is the default delimiter which is used by
  # all the browsers.
  mattr_accessor :answers_delimiter
  self.answers_delimiter = "\r\n"

  mattr_accessor :inline_main_app_named_routes
  self.inline_main_app_named_routes = false

  def self.config
    yield(self)
  end
end
