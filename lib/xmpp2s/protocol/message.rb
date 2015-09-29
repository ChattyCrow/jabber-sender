require 'nokogiri'

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
        @xml ||= xml_node.doc.root.to_xml
      end

      private

      def xml_node
        Nokogiri::XML::Builder.new do |xml|
          xml.message(to: @jid, type: 'chat') {
            xml.body {
              xml << message
            }
          }
        end
      end
    end
  end
end
