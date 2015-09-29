module Xmpp2s
  module Protocol
    # Class represents bind resource XML
    class BindResource
      # Requires host
      attr_reader :resource

      def initialize(resource) # :nodoc:
        @resource = resource
      end

      def to_xml
        @xml ||= xml_node.doc.root.to_xml
      end

      private

      def xml_node
        Nokogiri::XML::Builder.new do |xml|
          xml.iq(type: 'set', id: '0') {
            xml.bind(xmlns: 'urn:ietf:params:xml:ns:xmpp-bind') {
              xml.resource {
                xml << @resource || ''
              }
            }
          }
        end
      end
    end
  end
end
