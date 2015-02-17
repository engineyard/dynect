class Dynect::Client
  class Real
    def create_cname(params={})
      refresh_token

      fqdn = "#{params['fqdn']}."
      zone = params['zone']
      target = "#{params['target']}."

      request(
        body:   {"rdata" => {"cname" => target}}.to_json,
        path:   "/REST/CNAMERecord/#{zone}/#{fqdn}",
        method: 'POST'
      )
    end
  end

  class Mock
    def create_cname(params={})
      fqdn = params['fqdn']
      zone = params['zone']
      target = params['target']

      data = {
        "data" => {
          "zone" => zone,
          "ttl" => 60,
          "fqdn" => fqdn,
          "record_type" => "CNAME",
          "record_id" => 0,
        }
      }

      self.data[:cnames][zone] ||= {}
      self.data[:cnames][zone][fqdn] = data

      response(
        body: data,
        status: 200
      )
    end
  end
end
