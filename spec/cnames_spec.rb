require 'spec_helper'

RSpec.configure do |config|
  config.include(CnameHelper)
end

describe 'servers' do
  let!(:client) { create_client }

  it 'can create a new cname' do
    cname = make_cname()
    expect(cname).to be
  end

  it 'can get a cname' do
    fqdn = rando_fqdn('ey.io')
    make_cname(fqdn: fqdn, zone: 'ey.io')

    cname = client.cnames.get(zone: 'ey.io', fqdn: fqdn)

    expect(cname.fqdn).to eq(fqdn)
  end
end
