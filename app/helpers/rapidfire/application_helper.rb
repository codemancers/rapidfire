module Rapidfire
  module ApplicationHelper
    def render_answer_form_helper(answer, form)
      partial = answer.question.type.to_s.split("::").last.downcase
      render partial: "rapidfire/answers/#{partial}", locals: { f: form, answer: answer }
    end

    def checkbox_checked?(answer, option)
      answers_delimiter = Rapidfire.answers_delimiter
      answers = answer.answer_text.to_s.split(answers_delimiter)
      answers.include?(option)
    end

    def method_missing(method, *args, &block)
      if main_app_url_helper?(method)
        main_app.send(method, *args)
      else
        super
      end
    end

    def respond_to?(method)
      main_app_url_helper?(method) || super
    end

    private

    def main_app_url_helper?(method)
      Rapidfire.inline_main_app_named_routes &&
        (method.to_s.end_with?('_path') or method.to_s.end_with?('_url')) &&
        main_app.respond_to?(method)
    end
  end
end
