require "nifipi/version"

module Nifipi
  class Nifi
    attr_accessor :host, :port
    def initialize(host, port)
      @host = host
      @port = port
    end  
  end 
end
