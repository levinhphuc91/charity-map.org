require 'fb_graph'
class SendMessage
  class << self
    def fb(params, user)
      default_params = {
        :message     => "",
        :picture     => "http://cl.ly/image/3P0q2j3O2T0U/logo_square.png",
        :link        => "http://www.charity-map.org",
        :name        => "Charity Map",
        :description => "Bản Đồ Từ Thiện (Charity Map) là trang web gây quỹ cộng đồng dành cho các dự án xã hội tại Việt Nam."
      }
      params = default_params.merge(params)
      client = FbGraph::User.me(user.facebook_credentials["token"])
      client.feed!(params) if Rails.env.production?
    end
  end
end