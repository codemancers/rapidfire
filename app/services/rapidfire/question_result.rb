module Rapidfire
  class QuestionResult < Rapidfire::BaseService
    include ActiveModel::Serialization

    def initialize(question, results)
      @question, @results = question, results
    end
    attr_accessor :question, :results

    def active_model_serializer
      Rapidfire::QuestionResultSerializer
    end
  end
end
