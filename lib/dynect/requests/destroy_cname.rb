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
      cname = self.data[:cname][zone][fqdn]
      unless cname
        response(
          :body => {"error" => "Couldn't find Cname #{fqdn}}"},
          :status => 404
        )
      end

      data = {
        "data" => {
          "zone" => data['zone'],
          "ttl" => 60,
          "fqdn" => data['fqdn'],
          "record_type" => "CNAME",
          "record_id" => 0,
        }
      }

      response(
        body: data,
        status: 200
      )
    end
  end
end
