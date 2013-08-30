module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    belongs_to :tenant
    has_many   :questions
    has_many   :answer_groups
    validates  :name, :presence => true

    def self.by_tenant(current_tenant)
      if current_tenant
        where(tenant_id: current_tenant.id, tenant_type: current_tenant.type)
      else
        self
      end
    end

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name
    end
  end
end
