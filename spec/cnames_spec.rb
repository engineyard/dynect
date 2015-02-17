require 'spec_helper'

RSpec.configure do |config|
  config.include(CnameHelper)
end

describe 'servers' do
  let!(:client) { create_client }

  it 'can create a new cname' do
    cname = create_cname
    expect(cname).to be
  end
end
