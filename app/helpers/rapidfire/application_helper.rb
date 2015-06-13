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

    def data_for_dependency(answer)
      dependency = answer.question.question_dependency

      {
        dependent_answer_options: dependency.dependent_answer_options,
        dependent_on_id: dependency.dependent_on.id
      }
    end
  end
end
