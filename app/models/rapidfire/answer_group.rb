module Rapidfire
  class AnswerGroup < ActiveRecord::Base
    belongs_to :question_group
  end
end
