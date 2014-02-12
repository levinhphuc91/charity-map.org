require 'httparty'
require 'uri'

class Charitio
  include HTTParty
  BASE_URI = (Rails.env.development? ? 'staging-charitio.herokuapp.com/v1' : 'api.charity-map.org/v1')
  ssl_version :SSLv3

  def initialize(email, token)
    @token, @email = token, email
    @admin_token = ENV['API_CREATE_USER_TOKEN']
  end

  def get_transactions(params)
    fetch('/transactions', params)
  end

  def get_credits(params)
    fetch('/credits', params)
  end
    
  def get_unprocessed_credits(params)
    fetch('/credits/unprocessed/' + params[:master_transaction_id])
  end

  def get_cleared_credits(params)
    fetch('/credits/cleared/' + params[:master_transaction_id])
  end

  def get_pending_clearance_credits(params)
    fetch('/credits/cleared/' + params[:master_transaction_id])
  end

  def create_transaction(params)
    push('/transactions', params)
  end

  def create_user(params)
    admin_push('/users/create', params)
  end

  def user_balance(params)
    admin_fetch('/users/balance', params).response["balance"]
  end

  private
    def fetch(path, params = {})
      @http = HTTParty.get('https://' + BASE_URI + path,
        body: params,
        headers: { "Authorization" => "Token token=#{@token}" })
      @decode = Decode.new(@http)
    end

    def push(path, params)
      @http = HTTParty.post('https://' + BASE_URI + path,
        body: params,
        headers: { "Authorization" => "Token token=#{@token}" })
      @decode = Decode.new(@http)
    end

    def admin_fetch(path, params)
      @http = HTTParty.get('https://' + BASE_URI + path,
        body: params,
        headers: { "Authorization" => "Token token=#{@admin_token}" })
      @decode = Decode.new(@http)
    end

    def admin_push(path, params)
      @http = HTTParty.post('https://' + BASE_URI + path,
        body: params,
        headers: { "Authorization" => "Token token=#{@admin_token}" })
      @decode = Decode.new(@http)
    end

    def request_uri(path, hash = {})
      if hash.empty?
        path
      else
        query_params = hash.map do |key, values|
          Array(values).map { |value| "#{URI.escape(key.to_s)}=#{URI.escape(value)}" }
        end

        path + '?' + query_params.flatten.join('&')
      end
    end
end

class Decode
  def initialize(http)
    @http = http
  end

  def response
    @http.parsed_response
  end

  def ok?
    [200, 201].index(@http.response.code.to_i) != nil
  end
end