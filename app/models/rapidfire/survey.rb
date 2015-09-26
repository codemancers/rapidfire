module Rapidfire
  class Survey < ActiveRecord::Base
    has_many  :questions
    validates :name, :presence => true

    if Rapidfire.enable_tenancy
      belongs_to :tenant, class_name: Rapidfire.tenant_class
      validates :tenant, :presence => true
    end

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name
    end
  end
end
