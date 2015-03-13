module Rapidfire
  class QuestionDependency < ActiveRecord::Base
    belongs_to :dependent_on, class_name: 'Rapidfire::Question'
    belongs_to :question, class_name: 'Rapidfire::Question'
  end
end
