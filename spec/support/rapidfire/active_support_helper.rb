module Rapidfire
  module ActiveSupportHelper
    # Helps in removing model, and force-reloading it next time This helper does 2
    # things:
    # * remove from $LOADED_FEATURES so that ruby 'require' reloads file again
    # * remove the constant from active support dependencies
    def self.clear_model(model_name)
      ActiveSupport::Dependencies.remove_constant('Rapidfire::' + model_name)

      models_dir = File.dirname(__FILE__) + '/../../../app/models/rapidfire/'
      path = File.expand_path(models_dir + model_name.downcase + '.rb')
      $LOADED_FEATURES.delete(path)
    end
  end
end
