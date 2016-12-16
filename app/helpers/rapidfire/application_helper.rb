module Rapidfire
  module ApplicationHelper
    def render_answer_form_helper(answer, form)
      type = answer.question.type ? answer.question.type : answer.question[:type]
      partial = type.to_s.split("::").last.downcase
      render partial: "rapidfire/answers/#{partial}", locals: { f: form, answer: answer }
    end

    def checkbox_checked?(answer, option)
      answers_delimiter = Rapidfire.answers_delimiter
      answers = answer.answer_text.to_s.split(answers_delimiter)
      answers.include?(option)
    end
  end
end
