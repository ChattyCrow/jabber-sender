require 'base64'

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
        @xml ||= xml_node.doc.root.to_xml
      end

      private

      def xml_node
        Nokogiri::XML::Builder.new do |xml|
          xml.iq(to: @host, type: 'set', id: '1') {
            xml.session(xmlns: 'urn:ietf:params:xml:ns:xmpp-session')
          }
        end
      end
    end
  end
end
