class SMS
  class << self
    def send(to, body)
      account_sid = ENV['TWILIO_ACCOUNT_SID']
      auth_token = ENV['TWILIO_AUTH_TOKEN']
      @client = Twilio::REST::Client.new account_sid, auth_token
       
      message = @client.account.sms.messages.create(:body => "#{body}",
          :to => "+84#{to}",
          :from => "+13197743213")
      puts message.sid
    end
  end
end