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
      unless [:customer_name, :user_name, :password].all? {s.params.key?}
        return response(
          :body   => {"error" => "missing authentication params"},
          :status => 404,
        )
      end

      token = SecureRandom.hash(10)

      self.data[:tokens].push(token)

      response(
        :body   => {"data" => {"token" => token}},
        :status => 200,
      )
    end
  end
end
