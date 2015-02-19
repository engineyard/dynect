class Dynect::Client
  class Real
    def get_token(params={})
      request(
        :params => params,
        :path   => '/REST/Session',
        :method => :get,
      )
    end
  end

  class Mock
    def get_token(params={})
      response(
        body: '',
        status: 200
      )
    end
  end
end
