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
  end

  it 'gets the revision' do
    actual = @nifi.revision
    expect(actual.key? "clientId").to be
    expect(actual.key? "version").to be
    expect(actual.key? "lastModifier").to be
  end

  it 'creates a processor with a custom name' do
    type = "org.apache.nifi.processors.twitter.GetTwitter"
    add = rand
    opts = {
      "name" => "test-name-#{add}",
      "type" => type,
    }
    res = @nifi.create opts
    expect(res.code.to_i).to be < 400
    procs = @nifi.get_all.select{|p| p["name"] == opts["name"]}
    expect(procs.length).to eq(1)
  end

  it 'gets all connections' do 
    conns = @nifi.get_all_connections
    expect(conns.is_a?(Array)).to be
  end

  it 'creates a connection' do
    procs = []
    2.times do
      opts = {
        "name" => "conn-test-#{rand}",
        "type" => "org.apache.nifi.processors.twitter.GetTwitter",
      }
      created = @nifi.create(opts)
      procs << JSON.parse(created.body)["processor"]["id"]
    end

    conn_opts = { 
      "source" => {"id" => procs.first.to_s}, 
      "destination" => {"id" => procs.last.to_s}, 
      "selectedRelationships" => ["success"]}
    res = @nifi.create_connection conn_opts
    expect(res.code.to_i).to be < 400
  end
end
