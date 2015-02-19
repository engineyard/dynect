class Dynect::Client < Cistern::Service
  model_path "dynect/models"
  request_path "dynect/requests"

  model      :cname
  request    :create_token
  request    :get_token
  request    :get_cname
  request    :create_cname
  request    :destroy_cname
  request    :publish_zone
  collection :cnames

  requires :customer_name, :username, :password

  recognizes :logger, :adapter

  class Real
    attr_reader :connection, :password, :username, :customer_name, :url
    attr_accessor :token

    def initialize(options = {})
      @url           = 'https://api2.dynect.net/'
      @token         = false
      @customer_name = options[:customer_name]
      @username      = options[:username]
      @password      = options[:password]
      logger         = options[:logger] || Logger.new(nil)

      @connection = Faraday.new do |faraday|
        faraday.use Faraday::Response::RaiseError
        faraday.use Dynect::Session, self
        faraday.use Ey::Logger::Faraday, prefix: "dynect", format: :machine, device: logger

        faraday.response :json
        faraday.request :json
        faraday.adapter(*(options[:adapter] || Faraday.default_adapter))
      end
    end

    def request(options={})
      method = options[:method] || :get
      url    = options[:url] || File.join(@url.to_s, options[:path] || "/")
      params = options[:params] || {}
      body   = options[:body]

      headers = {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json'
      }.merge(options[:headers] || {})

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
  end

  class Mock
    attr_reader :connection
    attr_accessor :token

    def initialize(options={})
      @url = options[:url] || "http://fake-dyn-api.localhost"

      @customer_name = options[:customer_name]
      @username      = options[:username]
      @password      = options[:password]
    end

    def self.data
      @data ||= Hash.new { |h, url|
        h[url] = {
          :cnames => {},
          :tokens => [],
        }
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
