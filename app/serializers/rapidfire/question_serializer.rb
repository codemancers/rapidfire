module Rapidfire
  class QuestionSerializer < ActiveModel::Serializer
    self.root = false

    attributes :question_text, :answer_options

    def answer_options
      object.options
    end
  end
end
