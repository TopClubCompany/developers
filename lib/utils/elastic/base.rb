# -*- encoding : utf-8 -*-
module Utils
  module Elastic
    LANG_ANALYZERS = {
        :ru => 'Russian',
        :en => 'English',
        :ua => 'Ukraine'
    }

    custom_filters = [:ru, :en, :ua].each_with_object({}) do |l, h|
      h["custom_stop_#{l}"] = {
          "type" => "stop",
          "stopwords_path" => Rails.root.join("lib/data/stop_big_#{l}.txt").to_s
      }
      h["snow_#{l}"] = {
          "type" => "snowball", 'language' => LANG_ANALYZERS[l]
      }
    end

    n_gram_filters = {
        "ac_ngram" => {
            "type" => "nGram",
            "min_gram" => 1,
            "max_gram" => 50
        }
    }

    lang_analyzers = [:ru, :en, :ua].each_with_object({}) do |l, h|
      h["analyzer_#{l}"] = {
          "type" => "custom",
          "tokenizer" => "lowercase",
          "filter" => ["custom_stop_#{l}", "stop"]
      }
    end

    base_analyzers = {
        #"default" => {
        #    "type" => "custom",
        #    "type" => "custom",
        #    "tokenizer" => "standard",
        #    "filter" => ["asciifolding" "lowercase"]
        #}#,
        "ac_ngram" => {
            "type" => "custom",
            "tokenizer" => "lowercase",
            "filter" => ["ac_ngram"]
        }
    }

    ANALYZERS = {
        :analysis => {
            :filter => custom_filters.merge(n_gram_filters),
            :analyzer => base_analyzers.update(lang_analyzers)
        }
    }

    module Base
      def self.tire_models
        Dir.glob(Rails.root.to_s + '/app/models/**/*.rb').each { |file| require file }
        ActiveRecord::Base.descendants.find_all { |model| model.ancestors.map(&:name).grep(/^Tire/).any? }
      end

      def self.prepare_sym(path)
        file_name = File.basename(path)
        lines = File.readlines(path).map { |s| s.split(',').map(&:strip) }
        res = []
        lines.each do |line|
          res << line.map { |w| Product.build_stops(w, :analyzer => 'base_ru') }.flatten
        end
        res_path = Rails.root.join('tmp', file_name).to_s
        File.open(res_path, 'w+') { |f| f.write res.map { |r| r.join(',') }.join("\n") }
        res_path
      end

      #def self.prepare_all_synonyms
      #  ::I18n.available_locales.each do |l|
      #    prepare_sym(Rails.root.join("lib/data/synonym_#{l}.txt"))
      #  end
      #end
    end
  end
end