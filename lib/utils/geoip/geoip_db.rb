require "geoip"
module Utils
  module Geoip
    module GeoipDb
      extend self

      DATA_FILE_PATH = Rails.root.join('db/data')
      LOG_FILE = Rails.root.join('log', 'geo_db.log')
      LOGGER = Utils::Base::Logger.for_file(LOG_FILE)

      def search(str)
        LOGGER.debug("lookup #{str}")
        GeoIP.new(Rails.root.join('db/data', 'GeoLiteCity.dat')).city(str)
      rescue
        false
      end

      def update_all
        dbs = [
            ['GeoIP', 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz'],
            ['GeoIPASNum', 'http://geolite.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz'],
            ['GeoLiteCity', 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz']
        ]
        dbs.each do |db|
          update_db(db[0], db[1])
        end
      end

      def update_db(package_name, url)
        shellscripts_path = File.dirname(__FILE__)
        target = File.join(DATA_FILE_PATH, "#{package_name}.dat")
        LOGGER.info("updating #{package_name} - #{url}")
        if File.exists?(target) and File::ctime(target) > Time.now - (30*24*60*60)
          LOGGER.info("Datafile #{package_name} is up to date, skipping")
        else
          `cd #{shellscripts_path} && ./install_db #{url} #{DATA_FILE_PATH} >> #{LOG_FILE} 2>&1`
        end
        LOGGER.info("complete #{package_name}")
      end
    end
  end
end

