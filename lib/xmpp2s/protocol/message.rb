require 'xml'

module Xmpp2s
  module Protocol
    # Class represents authenticate XML
    class Message
      # Requires host
      attr_reader :jid

      # Mechanism
      attr_reader :message

      def initialize(jid, message) # :nodoc:
        @jid = jid
        @message = message
      end

      def to_xml
        @xml ||= xml_node.to_s
      end

      private

      def xml_node
        # Create message node
        node = XML::Node.new('message')
        node.attributes['to']   = @jid
        node.attributes['type'] = 'chat'

        # Create body node
        body = XML::Node.new('body')
        body.content = @message

        # Set body to parent
        node << body

        # Return node
        node
      end
    end
  end
end
