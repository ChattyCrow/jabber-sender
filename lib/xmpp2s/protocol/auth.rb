require 'base64'

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
        @xml ||= xml_node.doc.root.to_xml
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

        # Return nokogiri builder
        Nokogiri::XML::Builder.new do |xml|
          xml.auth(xmlns: 'urn:ietf:params:xml:ns:xmpp-sasl', mechanism: auth) {
            xml << auth_text
          }
        end
      end
    end
  end
end
