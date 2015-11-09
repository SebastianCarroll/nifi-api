require "nifipi/version"
require "json"
require "net/http"

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

    def get_all
      uri = URI("http://#{@host}:#{@port}/nifi-api/controller/process-groups/root/processors")
       procs= JSON.parse(Net::HTTP.get_response(uri).body)
      return procs["processors"]
    end

    def revision
      uri = URI("http://#{@host}:#{@port}/nifi-api/controller/revision")
      revision = JSON.parse(Net::HTTP.get_response(uri).body)
      return revision["revision"]
    end
  end 
end
