class Dynect::Client
  class Real
    def create_token(params={})
      request(
        params: params,
        path:   '/REST/Session',
        method: 'POST'
      )
    end
  end

  class Mock
    def create_token(params={})
      ['customer_name', 'user_name', 'password'].each do |p|
        unless params[p]
          return response(
            :body   => {"error" => "missing authentication param #{p}"},
            :status => 404
          )
        end
      end

      token = SecureRandom.hash()

      self.data[:tokens].push(token)

      response(
        :body   => {"data" => {"token" => token}},
        :status => 200,
      )
    end
  end
end
