require 'base64'
require 'xml'

module Xmpp2s
  module Protocol
    # Class represents authenticate XML
    class Session
      # Requires host
      attr_reader :host

      def initialize(host) # :nodoc:
        @host = host
      end

      def to_xml
        @xml ||= xml_node.to_s
      end

      private

      def xml_node
        node = XML::Node.new('iq')
        node.attributes['to'] = @host
        node.attributes['type'] = 'set'
        node.attributes['id'] = '1'

        # Session node
        session = XML::Node.new('session')
        session.attributes['xmlns'] = 'urn:ietf:params:xml:ns:xmpp-session'
        node << session

        # Return node
        node
      end
    end
  end
end
