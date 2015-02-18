class Dynect::Client < Cistern::Service
  model_path "dynect/models"
  request_path "dynect/requests"

  model      :cname
  request    :create_token
  request    :get_cname
  request    :create_cname
  request    :destroy_cname
  collection :cnames

  requires :customer_name, :user_name, :password

  class Real
    attr_reader :connection
    attr_accessor :token

    def initialize(opts = {})
      @url = 'https://api2.dynect.net/'
      @token = false

      @customer_name = opts[:customer_name]
      @user_name = opts[:user_name]
      @password = opts[:password]

      @connection = Faraday.new do |faraday|
        faraday.use Faraday::Response::RaiseError
        faraday.use Faraday::Response::Logger

        faraday.response :json
        faraday.request :json
        faraday.adapter Faraday.default_adapter
      end

      refresh_token
    end

    def request(options={})
      method = (options[:method] || 'get').to_s.downcase.to_sym
      url = Addressable::URI.parse(options[:url] || File.join(@url.to_s, options[:path] || "/"))
      url.query_values = (url.query_values || {}).merge(options[:query] || {})
      params = options[:params] || {}
      body = options[:body]

      headers = {'Accept' => 'application/json','Content-Type' => 'application/json'}.merge(options[:headers] || {})
      headers.merge!('Auth-Token' => @token) if @token

      response = @connection.send(method) do |req|
        req.url(url.to_s)
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body = body
      end

      Dynect::Response.new(
        :status  => response.status,
        :headers => response.headers,
        :body    => response.body,
        :request => {
          :method  => method,
          :url     => url,
          :body    => body,
          :headers => headers,
        }
      )
    end

    def refresh_token
      begin
        return if get_token.status == 200
      rescue Faraday::ResourceNotFound, Faraday::ClientError
        response = create_token({
          'customer_name' => @customer_name,
          'user_name' => @user_name,
          'password' => @password
        }).body

        unless response['data']['token']
           Rails.logger.error {'Failed to get dynect token!'}
           raise 'Failed to get dynect token!'
        end

        @token = response['data']['token']
      else
        Rails.logger.error {'Failed to get dynect token!'}
        raise 'unable to create dynect token!'
      end
    end

    def get_token(params={})
      request(
        params: params,
        path:   '/REST/Session',
        method: 'GET'
      )
    end
  end

  class Mock
    attr_reader :connection
    attr_accessor :token

    def initialize(opts={})
      @url = opts[:url] || "http://fake-dyn-api.localhost"

      @customer_name = opts[:customer_name]
      @user_name = opts[:user_name]
      @password = opts[:password]

      refresh_token
    end

    def refresh_token
      response = create_token({
        'customer_name' => @customer_name,
        'user_name' => @user_name,
        'password' => @password
      }).body

      @token = response['data']['token']
    end

    def self.data
      @data ||= {
        cnames: {},
        tokens: []
       }
    end

    def self.reset!
      @data = nil
    end

    def data
      self.class.data
    end

    def response(options={})
      url     = options[:url] || File.join(@url.to_s, options[:path] || "/")
      method  = (options[:method] || :get).to_s.to_sym
      status  = options[:status] || 200
      body    = options[:body]
      headers = {
        "Content-Type" => "application/json; charset=utf-8"
      }.merge(options[:headers] || {})

      headers.merge!('Auth-Token' => @token) if @token

      Dynect::Response.new(
        :status  => status,
        :headers => headers,
        :body    => body,
        :request => {
          :method  => method,
          :url     => url,
          :body    => body,
          :headers => headers,
        }
      )
    end
  end
end

class Dynect::Error < StandardError
  attr_reader :response

  def initialize(response)
    @response = response
  end
end
