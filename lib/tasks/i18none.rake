desc "Prepare attribute translations for AR models"

namespace :i18n do
  task :models => :environment do
    Utils::I18none::ModelTranslator.prepare_attr_i18n
  end
end