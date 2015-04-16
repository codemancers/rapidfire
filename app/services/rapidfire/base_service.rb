module Rapidfire
  class BaseService
    if Rails::VERSION::MAJOR == 4
      include ActiveModel::Model
    else
      extend  ActiveModel::Naming
      include ActiveModel::Conversion
      include ActiveModel::Validations

      def persisted; false end

      def initialize(params = {})
        with_params(params)
        super()
      end
    end

    def with_params(params = {})
      params.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if params.size()

      self
    end

    # Base class for all the errors
    class BaseServiceError < StandardError; end

    # Provide a generic interface for performing an action, and capturing common
    # errors, like ActiveRecord::RecordInvalid etc
    def capture_errors
      yield
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each do |error|
        errors.add(:base, error)
      end
      false
    rescue BaseServiceError => e
      # no need to collect any errors, they are already added to errors
      false
    end
  end
end
