require 'nexmo'
class SMS
  class << self
    def send(to, body)
      nexmo = Nexmo::Client.new(ENV['CM_NEXMO_SID'],ENV['CM_NEXMO_SECRET'])
      response = nexmo.send_message!({:to => "0084#{to}", :from => "Charity Map", :text => "#{body}"})
    end
  end
end