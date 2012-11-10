# -*- encoding : utf-8 -*-'
module Utils
  module Auth
    module SocCallbackParser
      def get_data_from_callback raw_data
        data = Hashie::Mash.new([:first_name, :last_name, :email, :phone, :name].inject({}) { |simple_fields, field| simple_fields.merge({field => raw_data.info[field].to_s}) })
        data.provider   = raw_data.provider.to_s
        data.token      = raw_data.credentials!.token
        data.secret     = raw_data.credentials!.secret
        data.url        = (raw_data.extra!.response!.identity_url or raw_data.urls![data.provider.to_sym.capitalize])
        google_uid      = raw_data.uid.to_s.match(/id=(?<id>\w+)/)
        raw_data        = (data.provider == 'google' ? raw_data.info : (raw_data.info.merge raw_data.extra.raw_info))
        data.photo      = (raw_data.photo_big or raw_data.image)
        data.patronymic = raw_data.middle_name
        data.address    = (raw_data.location.kind_of?(Hash) ? raw_data.location.name : raw_data.location)
        data.birthday   = (raw_data.birthday or raw_data.bdate)
        data.uid        = google_uid ? google_uid[:id] : (raw_data.id or raw_data.uid)
        data.language   = (raw_data.lang or raw_data.locale)
        data.gender     = (raw_data.gender or raw_data.sex)
        data
      end
    end
  end
end