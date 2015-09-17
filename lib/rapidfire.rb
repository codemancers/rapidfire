require "rapidfire/engine"

module Rapidfire
  class AccessDenied < StandardError
  end

  # configuration which will be used as delimiter in case answers are bunch
  # of collection values. This is the default delimiter which is used by
  # all the browsers.
  mattr_accessor :answers_delimiter
  self.answers_delimiter = "\r\n"

  # If app is multi tenant, then tenancy can be enabled by setting this
  # accessor to true, and specifying tenant class.
  mattr_accessor :enable_tenancy
  self.enable_tenancy = false

  mattr_accessor :tenant_class
  self.tenant_class = nil


  def self.config
    yield(self)
  end
end
