module Rapidfire
  module ApplicationHelper
    def render_answer_form_helper(answer, form)
      partial = answer.question.type.to_s.split("::").last.downcase
      render partial: "answer_wrapper", locals: { f: form, answer: answer, partial: partial }
    end

    def checkbox_checked?(answer, option)
      answers_delimiter = Rapidfire.answers_delimiter
      answers = answer.answer_text.to_s.split(answers_delimiter)
      answers.include?(option)
    end

    def filter_link(question_id, option)
      question_id = question_id.to_s
      option = option.to_s

      this_filter = {
        question_ids: (params.dig(:filter, :question_ids) || []).map(&:to_s),
        options: (params.dig(:filter, :options) || []).map(&:to_s)
      }

      if this_filter[:question_ids].include?(question_id) && this_filter[:options].include?(option)
        question_index = this_filter[:question_ids].index(question_id)
        this_filter[:question_ids].delete_at(question_index) if question_index

        option_index = this_filter[:options].index(option)
        this_filter[:options].delete_at(option_index) if option_index

        action_description = "Remove from"
      else
        this_filter[:question_ids] << question_id
        this_filter[:options] << option
        action_description = "Add to"
      end

      link_to "#{action_description} Filter", filter: this_filter
    end
  end
end
