#require File.expand_path('lib/omniauth/strategies/top_club', Rails.root)
Rails.configuration.middleware.use OmniAuth::Builder do
  #provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
#  unless RUBY_PLATFORM =~ /darwin/
#    #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
#    provider :facebook, configatron.facebook.app_id, configatron.facebook.app_secret,
#             {
#                 :scope => configatron.facebook.scope, :setup => true,
#                 :client_options => {:ssl => {:ca_file => "/etc/pki/tls/certs/ca-bundle.crt"}}
#             }
#    provider :twitter, configatron.twitter.app_id, configatron.twitter.app_secret
#    provider :vkontakte, configatron.vk.app_id, configatron.vk.app_secret,
#             {
#                 :scope => configatron.vk.scope, :setup => true,
#                 :client_options => {:ssl => {:ca_file => "/etc/pki/tls/certs/ca-bundle.crt"}}
#             }
#  else
#    provider :facebook, configatron.facebook.app_id, configatron.facebook.app_secret, { :scope => configatron.facebook.scope, :setup => true}
#    provider :twitter, configatron.twitter.app_id, configatron.twitter.app_secret
#    provider :vkontakte, configatron.vk.app_id, configatron.vk.app_secret, { :scope => configatron.vk.scope, :setup => true }
#  end
#  provider :abitant, configatron.abitant.app_id, configatron.abitant.app_secret
end
#OmniAuth.config.full_host = 'http://apps.facebook.com/dev_brain/'
