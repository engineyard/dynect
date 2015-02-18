class Dynect::Client::Cname < Cistern::Model
  identity :record_id

  attribute :zone
  attribute :ttl
  attribute :fqdn
  attribute :record_type
  attribute :rdata
  attribute :target

  def save
    requires :zone, :fqdn, :target

    params = {
      'record_id' => SecureRandom.random_number(100),
      'zone' => self.zone,
      'fqdn' => self.fqdn,
      'target' => self.target
    }

    if new_record?
      merge_attributes(connection.create_cname(params).body['data'])
    end
  end
end
