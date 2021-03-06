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
      @base_uri = "http://#{@host}:#{@port}/nifi-api/controller"
      @rev_url = "#{@base_uri}/revision"
      @proc_url = "#{@base_uri}/process-groups/root/processors"
      @conn_url = "#{@base_uri}/process-groups/root/connections"
    end  

    # Gets the current version of the flow file NiFi is running
    def version
      rev = revision
      return rev["version"]
    end

    # Returns all the current processes in JSON format
    def get_all
      uri = URI(@proc_url)
      procs= JSON.parse(Net::HTTP.get_response(uri).body)
      return procs["processors"]
    end

    # Queries NiFi for the current revision object
    def revision
      uri = URI(@rev_url)
      revision = JSON.parse(Net::HTTP.get_response(uri).body)
      return revision["revision"]
    end

    # Create a processor
    # Params:
    # +opts+: Hash representation of the ProcessorDTO
    #  Must contain key "type" which is the fully qualified java type of the processor
    #
    # Examples:
    # Minimal:
    # nifi.create {"type" => "org.apache.nifi.processors.twitter.GetTwitter"}
    #
    # Custom name:
    # opts = {"type" => "org.<etc>.GetTwitter", "name" => "random-test-99"}
    # nifi.create opts
    def create(opts)
      uri = URI(@proc_url)
      data = {
        "revision" => revision,
        "processor" => opts,
      }
      req = Net::HTTP.new(@host, @port)
      res = req.post(uri.path, data.to_json, Nifipi::JSON_HEADER)
      return res
    end

    # Queries service for all connections
    def get_all_connections
      resp = JSON.parse(Net::HTTP.get_response(URI(@conn_url)).body)
      resp["connections"]
    end

    def create_connection(opts)
      uri = URI(@conn_url)
      data = {
        "revision" => revision,
        "connection" => opts,
      }
      req = Net::HTTP.new(@host, @port)
      res = req.post(uri.path, data.to_json, Nifipi::JSON_HEADER)
      return res
    end
  end 
end
