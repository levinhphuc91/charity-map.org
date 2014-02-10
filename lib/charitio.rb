require 'httparty'
require 'uri'

class Charitio
  include HTTParty
  base_uri 'api.charity-map.org/v1'
  ssl_version :SSLv3

  def initialize(email, token)
    @token, @email = token, email
  end

  def get_transactions(params)
    fetch('/transactions', params)
  end

  def get_credits(params)
    fetch('/credits', params)
  end
    
  def get_unprocessed_credits(params)
    fetch('/credits/unprocessed/#{params[:master_transaction_id]}')
  end

  def get_cleared_credits(params)
    fetch('/credits/cleared/#{params[:master_transaction_id]}')
  end

  def get_pending_clearance_credits(params)
    fetch('/credits/cleared/#{params[:master_transaction_id]}')
  end

  def create_transaction(params)
    push('/transactions', params)
  end

  private
    def fetch(path, params = {})
      @http = HTTParty.get("https://api.charity-map.org/v1" + path, params)
        # :headers => { "Authorization" => "Token token=#{@token}" })
      @decode = Decode.new(@http)
    end

    def push(path, params)
      @http = HTTParty.post("https://api.charity-map.org/v1" + path, params)
      # :headers => { "Authorization" => "Token token=#{@token}" })
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