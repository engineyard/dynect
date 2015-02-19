require 'spec_helper'

describe 'tokens' do
  let!(:client) { create_client }

  it 'new clients auto register for their first token' do
    expect(client.token).to be
  end

  it 'can refresh its token' do
    client.token = nil


    expect(client.token).to be
  end
end

