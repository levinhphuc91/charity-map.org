require 'nexmo'

class SMS
  class << self
    def send(params)
      default_params = {
        to: nil,
        text: nil,
        sender_id: false
      }
      params = default_params.merge(params)
      params.each do |key, value|
        raise "#{key} cannot be nil" if value.nil?
      end

      if Rails.env.production? || Rails.env.development?
        if params[:sender_id] == true
          nexmo = Nexmo::Client.new(ENV['CM_NEXMO_SID'],ENV['CM_NEXMO_SECRET'])
          response = nexmo.send_message!({
            :to => "84#{params[:to]}", 
            :from => ENV['CM_NEXMO_SENDER_ID'], 
            :text => params[:text]
          })
        else
          nexmo = Nexmo::Client.new(ENV['CM_NEXMO_2ND_SID'],ENV['CM_NEXMO_2ND_SECRET'])
          response = nexmo.send_message!({
            :to => "84#{params[:to]}", 
            :from => ENV['CM_NEXMO_NO'], 
            :text => params[:text]
          })
        end
        return response
      end
    end
  end
end