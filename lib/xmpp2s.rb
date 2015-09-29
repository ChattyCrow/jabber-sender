# Default GEM namespace
module Xmpp2s
  # Error raised when response from server is malformed
  class XMLMalformedError < StandardError; end

  # Authentication error
  class AuthenticationError < StandardError; end

  # Invalid jabber server (unabble to connect - offline, timeout etc..)
  class ConnectionFailed < StandardError; end

  # Protocol error - Invalid Host etc..
  class ProtocolError < StandardError; end

  # Undelivered message
  class UndeliveredMessage < StandardError; end

  # Debugging!
  DEBUG = false # :nodoc:
end

# Loading required modules
require 'xmpp2s/jid'
require 'xmpp2s/protocol/start_stream'
require 'xmpp2s/protocol/bind_resource'
require 'xmpp2s/protocol/auth'
require 'xmpp2s/protocol/message'
require 'xmpp2s/protocol/session'
require 'xmpp2s/version'
require 'xmpp2s/auth'
require 'xmpp2s/connection'
require 'xmpp2s/session'
