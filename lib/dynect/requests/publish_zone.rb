class Dynect::Client
  class Real
    def publish_zone(params={})
      refresh_token

      zone = params['zone']
      data = {"publish" => "true"}

      request(
        body:   data.to_json,
        path:   "/REST/Zone/#{zone}",
        method: 'PUT'
      )
    end
  end

  class Mock
    def publish_zone(params={})
      data = {
        "data" => {
          'zone_type' => 'Primary',
          'serial_style' => 'increment',
          'serial' => 21,
          'zone' => 'EY.IO'
        }
      }

      response(
        body: data,
        status: 200
      )
    end
  end
end
