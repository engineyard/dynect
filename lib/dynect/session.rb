class Dynect::Session
  attr_reader :container

  def initialize(app, container, options={})
    @app       = app
    @container = container
  end

  def call(request_env)
    container.token ||= get_token

    request_env[:request_headers].merge!('Auth-Token' => container.token)

    @app.call(request_env).on_complete do |response_env|
      # @todo check if token has expired
    end
  end

  def get_token
    request_env = Faraday::Env.from(
      :method          => :post,
      :url             => URI.parse(File.join(container.url, "/REST/Session")),
      :request_headers => {"Accept" => "application/json", "Content-Type" => "application/json"},
      :request         => {},
      :ssl             => {},
      :body            => {
        'customer_name' => container.customer_name,
        'user_name'     => container.username,
        'password'      => container.password
      }
    )

    @app.call(request_env).on_complete do |response_env|
      Faraday::Response::RaiseError.new.on_complete(response_env)
    end.body["data"]["token"]
  end
end
