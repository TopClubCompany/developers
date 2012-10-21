# -*- encoding : utf-8 -*-
require File.expand_path('../yaml_waml', __FILE__)

module Utils
  module I18none
    class ModelTranslator

      MODELS = [
          AdminComment, Asset, Header, Locator, StaticPage, Structure, User, Account, Category

      ]

      IGNORE_COLUMNS = %w(id reset_password_sent_at remember_created_at current_sign_in_at confirmation_token
                      reset_password_token password_salt failed_attempts)

      def initialize
        @locales = Globalize.available_locales
        @models = MODELS
        @models_i18n_hash = {}
      end

      def make_hash
        @locales.each do |locale|
          I18n.with_locale(locale) do
            @models_i18n_hash[locale] = {'activerecord' => {'attributes'=> {}, 'models' => {}}}

            models_hash = @models.each_with_object({}) do |model, h|
              model_i18n = {
                  'zero' => model.model_name.human(:count => 0),
                  'one' => model.model_name.human(:count => 1),
                  'few' => model.model_name.human(:count => 2),
                  'many' => model.model_name.human(:count => 9)
              }
              @models_i18n_hash[locale]['activerecord']['models'][model.model_name.i18n_key.to_s]= model_i18n
              attributes = model.columns.map(&:name)
              attributes.concat(model.translated_attribute_names.map(&:to_s)) if model.translates?
              attributes.reject! { |el| IGNORE_COLUMNS.include?(el) }
              h[model.model_name.underscore] = attributes.each_with_object({}) do |attr, o|
                o[attr] = model.human_attribute_name(attr, :locale => locale).presence || attr
                model.reflect_on_all_associations.map(&:name).map(&:to_s).reject{|a| a =~ /^translation/ }.each do |assoc|
                  o[assoc] = model.human_attribute_name(assoc, :locale => locale)
                end
                if model.new.respond_to?("#{attr}_#{locale.to_s}".to_sym)
                  @locales.each do |locale_1|
                    o["#{attr}_#{locale_1.to_s}"] = "#{model.human_attribute_name(attr, :locale => locale)} (#{I18n.t(locale_1, :scope => [:attrs])})"
                  end
                end
              end.sort.to_hash
            end
            @models_i18n_hash[locale]['activerecord']['attributes'] = models_hash
          end
        end
      end

      def write_yaml
        locale_dir = Rails.root.join('config/locales')
        @locales.each do |locale|
          File.open(locale_dir.join("#{locale}.attrs.yml"), 'w') do |file|
            hash = {}
            hash[locale.to_s] = @models_i18n_hash[locale]
            file.write hash.to_yaml.force_encoding('UTF-8')
          end
        end
      end

      def self.prepare_attr_i18n
        model_translator = new
        model_translator.make_hash
        model_translator.write_yaml
      end
    end
  end
end
