module CnameHelper
  def create_cname(opts={})
    data = {}

    data[:zone] ||= Faker::Internet.domain_name
    data[:ttl] ||= 60
    data[:fqdn] ||= "#{Faker::Internet.domain_word}.#{Faker::Internet.domain_name}"
    data[:record_type] ||= "CNAME"
    data[:record_id] ||= 0

    client.cnames.create(data)
  end
end
