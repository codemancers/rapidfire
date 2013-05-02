module Rapidfire
  class AnswerGroup < ActiveRecord::Base
    belongs_to :question_group
    # attr_accessible :title, :body
  end
end
