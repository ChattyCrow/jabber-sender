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
        @xml ||= xml_node
      end

      private

      def xml_node
        <<-XML
          <stream:stream xmlns:stream='http://etherx.jabber.org/streams' xmlns='jabber:client' to='#{@domain}' xml:lang='en' version='1.0'>
        XML
      end
    end
  end
end
