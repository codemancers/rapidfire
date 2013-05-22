module Rapidfire
  class AnswerGroup < ActiveRecord::Base
    belongs_to :question_group
    has_many   :answers, inverse_of: :answer_group, autosave: true
  end
end
