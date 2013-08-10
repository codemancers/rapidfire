module Rapidfire
  class BaseService
    if Rails::VERSION::MAJOR == 4
      include ActiveModel::Model
    else
      extend  ActiveModel::Naming
      include ActiveModel::Conversion

      def persisted; false end
    end
  end
end
