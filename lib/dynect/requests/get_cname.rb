class Dynect::Client
  class Real
    def get_cname(params={})

      fqdn = params.fetch('fqdn')
      zone = params.fetch('zone')

      request(
        :path => "/REST/CNAMERecord/#{zone}/#{fqdn}/0/", # @fixme?
      )
    end
  end

  class Mock
    def get_cname(params={})
      fqdn = params['fqdn']
      zone = params['zone']

      unless self.data[:cnames][zone] && self.data[:cnames][zone][fqdn].is_a?(Hash)
        return response(
          body: {"error" => "cname not found"},
          status: 404,
        )
      end

      data = self.data[:cnames][zone][fqdn]

      response(
        body: data,
        status: 200
      )
    end
  end
end
