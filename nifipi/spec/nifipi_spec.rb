require 'spec_helper'

describe Nifipi do
  before(:each) do
    @host = 'localhost'
    @port = '8080'
    @nifi = Nifipi::Nifi.new @host, @port
  end

  it 'has a version number' do
    expect(Nifipi::VERSION).not_to be nil
  end

  it 'sets hostname and port on which to access api' do
    expect(@host).to eq(@nifi.host)
    expect(@port).to eq(@nifi.port)
  end

  it 'gets the version' do
    expect(@nifi.version.is_a? Numeric).to equal(true)
  end

  it 'has the correct json content headers' do
    expected= {"Content-Type" => "application/json"}
    expect(Nifipi::JSON_HEADER).to eq(expected)
  end

  it 'gets all processors' do
    #File.write('spec/test.txt', @nifi.get_all.to_s)
    procs = @nifi.get_all
    expect(procs.is_a?(Array)).to be
    expect(procs.length).to be > 0
  end

  it 'gets the revision' do
    actual = @nifi.revision
    expect(actual.key? "clientId").to be
    expect(actual.key? "version").to be
    expect(actual.key? "lastModifier").to be
  end
end
