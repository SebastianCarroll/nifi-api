require 'spec_helper'

describe Nifipi do
  it 'has a version number' do
    expect(Nifipi::VERSION).not_to be nil
  end

  it 'sets hostname and port on which to access api' do
    host = 'localhost'
    port = '8080'
    nifi = Nifipi::Nifi.new host, port
    expect(host).to eq(nifi.host)
    expect(port).to eq(nifi.port)
  end
end
