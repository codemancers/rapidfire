module Rapidfire
  class QuestionResult
    include ActiveModel::Serialization

    if Rails::VERSION::MAJOR == 4
      include ActiveModel::Model
    else
      extend  ActiveModel::Naming
      include ActiveModel::Conversion

      def persisted; false end
    end

    def initialize(question, results)
      @question, @results = question, results
    end
    attr_accessor :question, :results

    def active_model_serializer
      Rapidfire::QuestionResultSerializer
    end
  end
end
