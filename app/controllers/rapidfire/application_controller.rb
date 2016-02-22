module Rapidfire
  class ApplicationController < ::ApplicationController
    if Rapidfire.layout
      layout Rapidfire.layout
    end

    helper_method :can_administer?

    def authenticate_administrator!
      unless can_administer?
        raise Rapidfire::AccessDenied.new("cannot administer questions")
      end
    end
  end
end
