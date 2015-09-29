require 'base64'
require 'xml'

module Xmpp2s
  module Protocol
    # Class represents authenticate XML
    class Auth
      # Requires host
      attr_reader :jid

      # Password
      attr_reader :password

      # Mechanism
      attr_reader :mechanism

      def initialize(jid, password, mechanism) # :nodoc:
        @jid = jid
        @password = password
        @mechanism = mechanism
      end

      def to_xml
        @xml ||= xml_node.to_s
      end

      private

      def xml_node
        if @mechanism == Xmpp2s::Auth::SASL
          auth = 'PLAIN'
          auth_text = "#{Base64.encode64("\x00#{jid}\x00#{password}")}"
        else
          auth = 'ANONYMOUS'
          auth_text = ''
        end

        node = XML::Node.new('auth')

        # TODO: Change
        node.attributes['xmlns'] = 'urn:ietf:params:xml:ns:xmpp-sasl'
        node.attributes['mechanism'] = auth
        node << auth_text

        # Return node
        node
      end
    end
  end
end
