CharityMap::Application.middleware.use( Oink::Middleware, :logger => Hodel3000CompliantLogger.new(STDOUT), :instruments => :memory) if Rails.env.production?