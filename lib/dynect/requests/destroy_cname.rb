class Dynect::Client
  class Real
    def destroy_cname(params={})
      zone = params['zone']
      fqdn = params['fqdn']

      request(
        :method   => 'DELETE',
        :path     => "/REST/CNAMERecord/#{zone}/#{fqdn}"
      )
    end
  end

  class Mock
    def destroy_cname(params={})
      zone = params['zone']
      fqdn = params['fqdn']

      cname = self.data[:cnames][zone][fqdn]
      unless cname
        response(
          :status => 404
        )
      end

      self.data[:cnames][zone].delete(fqdn)

      response(
        body: data,
        status: 200
      )
    end
  end
end
