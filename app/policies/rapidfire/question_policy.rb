module Rapidfire
  class QuestionPolicy < ApplicationPolicy
    def index?
      true
    end

    def new?
      create?
    end

    def create?
      user.can_administer?
    end

    def edit?
      update?
    end

    def update?
      user.can_administer?
    end

    def destroy?
      user.can_administer?
    end

    def results?
      user.can_administer?
    end
  end
end
