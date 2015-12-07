module Xmpp2s
  # Class responsible to parsing JID
  class Jid
    # Pattern
    PATTERN = %r{^(?:(?<username>[^@]*)@)??(?<domain>[^@\/]*)(?:\/(?<resource>.*?))?$}.freeze

    # Domain
    attr_accessor :domain

    # Username
    attr_accessor :username

    # Resource
    attr_accessor :resource

    # Initialize JID class with proper data
    #
    # ==== Attributes
    #
    # * +jid+ - XMPPP JID identifier
    # * +domain+ - Optional domain (will be parsed from JID)
    # * +resource+ - Optional resource (will be parsed from JID)
    #
    def initialize(jid, domain = nil, resource = nil)
      @username, @domain, @resource = parse(jid)

      # Set initalize data
      @domain   = domain   if domain
      @resource = resource if resource

      # Test if domain is empty!
      if @domain.to_s.empty?
        fail ArgumentError, 'Couldn\'t create JID without domain'
      end
    end

    # Return jid in format of email address
    def jid
      "#{@username}@#{@domain}"
    end

    # Return full jid with resource
    def full_jid
      if @resource
        "#{jid}/#{@resource}"
      else
        jid
      end
    end

    def resource
      @resource || ''
    end

    # Parse node, domain and resource match PATTERN
    def parse(jid)
      jid.match(PATTERN).captures
    end
    private :parse
  end
end
