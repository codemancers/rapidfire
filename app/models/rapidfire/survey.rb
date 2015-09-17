module Rapidfire
  class Survey < ActiveRecord::Base
    has_many  :questions
    validates :name, :presence => true

    if Rapidfire.enable_tenancy
      belongs_to :tenant, class_name: Plutus.tenant_class
    end

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name
    end
  end
end
