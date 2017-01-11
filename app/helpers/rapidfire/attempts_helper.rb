module Rapidfire

  module AttemptsHelper
  end

  class AttemptFormBuilder < ActionView::Helpers::FormBuilder
    def span(method)
      @template.content_tag(:span, @object.send(method), 
                            id: (@object_name.gsub(/[\[\]]/, "_") << method.to_s))
    end
  end

end
