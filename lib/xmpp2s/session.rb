module Xmpp2s
  # Class responsible to session to jabber server. Please use default open method to save your time.
  class Session
    # Xmpp2s::Connection instance
    attr_accessor :connection

    # Open session instance and parse JID data.
    #
    # ==== Attributes
    #
    # * +jid+ - XMPP JID identifier
    # * +password+ - XMPP password which match to JID
    #
    # ==== Options
    #
    # * <tt>:port</tt> - specifies XMPP port (default <tt>5222</tt>)
    # * <tt>:domain</tt> - specifies XMPP domain (default is taken from <tt>JID</tt>)
    # * <tt>:host</tt> - specifies XMPP host server (default is taken from <tt>JID</tt>)
    # * <tt>:mechanism</tt> - authentication mechanism (default <tt>Xmpp2s::AUTH::SASL</tt>)
    # * <tt>:resource</tt> - resource (default is taken from <tt>JID</tt>)
    # * <tt>:timeout</tt> - default waiting time (default <tt>2</tt>)
    #
    # ==== Returns
    #
    #   Xmpp2s::Session instance or raise an exception on authentication error.
    #
    # ==== Examples
    #
    #   open 'test@jabber.org/home', 'password1234'
    #   open 'test@jabber.org/home', 'password1234', host: 'different_jabber_host.org'
    #   open 'test@jabber.org', 'password1234', resource: 'home'
    #   open 'test', 'password1234', host: 'jabber.org', resource: 'home'
    #
    def self.open(jid, password, options = {})
      # Create JID instance parser (if jid is String)
      jid = Xmpp2s::Jid.new(jid, options[:domain], options[:resource]) if jid.is_a?(String)

      # Set default values
      options[:port] ||= 5222
      options[:mechanism] ||= Xmpp2s::Auth::SASL
      options[:timeout] ||= 2
      options[:host] ||= jid.domain

      # Create session
      session = Xmpp2s::Session.new(jid, options[:host], options[:port], options[:timeout])

      # Try to authenticate user (raise error when invalid credentials are provided)
      unless session.authenticate(password, options[:mechanism])
        fail AuthenticationError, 'Invalid user credentials'
      end

      # Return session instance
      session
    end

    # Initialize XMPP session
    #
    # ==== Attributes
    #
    # * +jid+ - Xmpp2s::Jid instance
    # * +host+ - XMPP server host
    # * +port+ - XMPP server port
    # * +timeout+ - Waiting timeout
    #
    def initialize(jid, host, port, timeout)
      # Create connection to specific server
      @connection = Xmpp2s::Connection.new(jid, host, port, timeout)
    end

    # Return JID instance
    def jid
      @connection.jid
    end

    # Authentication
    #
    # ==== Attributes
    #
    # * +password+ - password
    # * +mechanism+ - default SASL(PLAIN)
    #
    # ==== Examples
    #
    #   authenticate 'password1234', false
    #
    def authenticate(password, mechanism)
      @connection.authenticate(password, mechanism)
    end

    # Send simple message to XMPP
    #
    # ==== Attributes
    #
    # * +jid+ - Target user JID
    # * +message+ - Message for target user
    #
    # ==== Example
    #
    #   send_message 'test2@jabber.org', 'Hello test2'
    #
    def send_message(jid, message)
      @connection.send_message(jid, message)
    end

    # Close connection if it is possible
    def close
      @connection.close
    end
  end
end
