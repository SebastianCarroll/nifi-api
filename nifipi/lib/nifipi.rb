require "nifipi/version"
require "json"

module Nifipi
  JSON_HEADER = {"Content-Type" => "application/json"}
  class Nifi
    attr_accessor :host, :port
    def initialize(host, port)
      @host = host
      @port = port
    end  

    def version
      uri = URI("http://#{@host}:#{@port}/nifi-api/controller/revision")
      revision = JSON.parse(Net::HTTP.get_response(uri).body)
      return revision["revision"]["version"]
    end
  end 
end
