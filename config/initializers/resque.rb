require 'resque'
Resque.redis.namespace = "top_club"

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == "top_club_shedule"
end