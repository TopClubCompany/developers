#require 'resque'
#Resque.redis.namespace = "abitant"
#
#Resque::Server.use(Rack::Auth::Basic) do |user, password|
#  password == "abitant"
#end