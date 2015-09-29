require 'xml'

module Xmpp2s
  module Protocol
    # Class represents start stream XML
    class StartStream
      # Requires host
      attr_reader :domain

      def initialize(domain) # :nodoc:
        @domain = domain
      end

      # Remove last /> we have to sent just opening tag!
      def to_xml
        @xml ||= begin
          str = xml_node.to_s
          str[-2] = ''
          str
        end
      end

      private

      def xml_node
        node = XML::Node.new('stream:stream')
        node.attributes['xmlns:stream'] = 'http://etherx.jabber.org/streams'
        node.attributes['xmlns']        = 'jabber:client'
        node.attributes['to']           = @domain
        node.attributes['xml:lang']     = 'en'
        node.attributes['version']      = '1.0'
        node
      end
    end
  end
end
