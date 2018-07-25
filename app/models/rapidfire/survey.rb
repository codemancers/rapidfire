module Rapidfire
  class Survey < ActiveRecord::Base
    has_many  :questions
    validates :name, :presence => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :introduction
    end

    def attempted? user = nil
      if(user.present?)
        Rapidfire::Attempt.exists? survey: self, user: user
      else
        Rapidfire::Attempt.exists? survey: self
      end
    end
  end
end
