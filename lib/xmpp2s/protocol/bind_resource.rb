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
        @xml ||= xml_node.to_s
      end

      private

      def xml_node
        node = XML::Node.new('iq')
        node.attributes['type'] = 'set'
        node.attributes['id']   = '0'

        # Add bind node
        bind_node = XML::Node.new('bind')
        bind_node.attributes['xmlns'] = 'urn:ietf:params:xml:ns:xmpp-bind'

        # Add resource node
        resource_node = XML::Node.new('resource')
        resource_node.content = @resource

        # Add child
        bind_node << resource_node
        node << bind_node

        # Return node
        node
      end
    end
  end
end
