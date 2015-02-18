module CnameHelper
  def make_cname(data={})
    data[:zone] ||= Faker::Internet.domain_name
    data[:ttl] ||= 60
    data[:fqdn] ||= rando_fqdn
    data[:record_type] ||= "CNAME"
    data[:target] ||= rando_fqdn

    client.cnames.create(data)
  end

  def rando_fqdn(zone = nil)
    zone ||= Faker::Internet.domain_name

    "#{Faker::Internet.domain_word}.#{zone}"
  end
end
