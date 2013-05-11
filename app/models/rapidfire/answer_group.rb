module Rapidfire
  class AnswerGroup < ActiveRecord::Base
    belongs_to :question_group
    has_many   :answers
  end
end
