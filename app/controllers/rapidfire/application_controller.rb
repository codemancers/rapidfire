module Rapidfire
  class ApplicationController < ::ApplicationController
    require 'pundit'
    include Pundit
    protect_from_forgery

    if Rapidfire.layout
      layout Rapidfire.layout
    end

    helper_method :current_user

    # Override prefixes to consider the scoped.
    # for method current_user
    def scoped
      :user
    end
  end
end
