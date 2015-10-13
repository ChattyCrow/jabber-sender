require 'socket'

module Xmpp2s
  # Class wraps TCP connection to jabber server
  class Connection
    # TCP Socket
    attr_accessor :socket

    # Timeout
    attr_accessor :timeout

    # Jid instance
    attr_accessor :jid

    # Authorization success?
    attr_accessor :authorized

    # Intialize Xmpp2s::Connection.
    #
    # ==== Attributes
    #
    # * +jid+ - Xmpp2s::JID Instance
    # * +host+ - XMPP server host
    # * +port+ - XMPP port
    # * +timeout+ - Timeout
    def initialize(jid, host, port, timeout)
      # Set jid reference
      @jid = jid

      # Set authorization to false!
      @authorized = false

      # Set timeout
      @timeout = timeout

      # Create TcpSocket to XMPP server
      @socket = TCPSocket.open(host, port)

      # Set socket options
      @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)

      # Start handshake
      start_stream
    end

    # Try to authenticate user
    #
    # === Attributes
    #
    # * +password+ - User password
    # * +mechanism+ - Authentication mechanism
    #
    # ==== Exception
    #
    # Can raise AuthenticationError if invalid login is provided.
    def authenticate(password, mechanism)
      # Check mechanism
      if (mechanism == Xmpp2s::Auth::SASL)
        # Check SASL authentication in features
        unless @features.include?('xmpp-sasl') && @features.include?('PLAIN')
          fail AuthenticationError, 'Unsupported Authentication'
        end
      else
        # Check non-sasl method
      end

      # Send authentitation XML
      send_data(Xmpp2s::Protocol::Auth.new(@jid.jid, password, mechanism))

      # Read authentication response from server
      response = read_data

      # Check
      if response.root.name != 'success'
        # Close connection
        close

        # Raise an unauthorized exception
        fail AuthenticationError, "Invalid login (#{response.root.child.name})"
      end

      # Start stream again
      start_stream

      # Bind resources
      bind_resource

      # Register session
      register_session

      # Return (success login)
      @authorized = true
    end

    # Send message.
    #
    # === Attributes
    #
    # * +jid+ - Target user jid
    # * +message+ - Message
    #
    # ==== Options
    #
    # * <tt>:raise_on_error</tt> - Raise an exception if message can not be delivered.
    def send_message(jid, message, options = {})
      # Raise exception when unauthorized
      fail AuthenticationError, 'You\'re not authorized!' unless @authorized

      # Send message
      send_data(Xmpp2s::Protocol::Message.new(jid, message))

      # Read message
      response = read_data(skip_empty_response: true)

      # Error response
      err_message = nil

      # Check if response is Nokogiri::Document document (indicates problem!)
      if response.is_a?(Nokogiri::XML::Document)
        # Find an error?
        if error_xml = response.xpath('//error').first
          # Error message
          err_message = error_xml.child.name

          # Log?
          puts "=== Error:\n#{err_message}\n\n" if Xmpp2s::DEBUG

          # Raise an exception?
          fail UndeliveredMessage, err_message if options[:raise_on_error]
        end
      end

      # Return true | false
      [ err_message.nil?, err_message ]
    end

    # Close connection
    def close
      # Guard
      return unless @socket

      # Try to correct session termination
      @socket.write('</stream:stream>') rescue nil

      # Shutdown and close socket
      @socket.shutdown rescue nil

      # Set socket to nil
      @socket = nil
    end

    private

    # Send data to socket.
    #
    # === Attributes
    #
    # * +klass+ - Klass which can be converted to xml <tt>to_xml</tt>
    def send_data(klass)
      # Raise connection close if socket not exists!
      fail ConnectionFailed, 'Connection closed' unless @socket

      # Debug output
      puts "=== Send:\n#{klass.to_xml}\n\n" if Xmpp2s::DEBUG

      # Write data into socket!
      @socket.write(klass.to_xml)
    end

    # Read data from socket.
    def read_data(options = {})
      # Wait until socket is ready
      result = IO.select([@socket], [], [], @timeout)

      # Empty response
      response = ''

      # Read data until data is available or timeout expires
      while result && (data = @socket.recv(1024)).length > 0
        response += data

        # Ensure we can read data immediatelly
        result = IO.select([@socket], [], [], @timeout)
      end

      # Add append text
      response += options[:append] if options[:append]

      # Recv log
      puts "=== Recv:\n #{response.length == 0 ? 'EMPTY' : response}\n\n" if Xmpp2s::DEBUG


      # Skip empty response
      if options[:skip_empty_response] && response.length == 0
        # Nothing to do...
        return ''
      end

      # Read an empty line! (not good)
      fail ConnectionFailed, 'Empty response' if response.length == 0

      # Parse response
      response =  Nokogiri::XML(response) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT
      end

      # Look for stream:error!
      if response.root.name == 'stream' && (child = response.root.child) && child.name == 'error'
        fail ConnectionFailed, child.child.name
      end

      # Parse response
      response
    rescue Nokogiri::XML::SyntaxError => e
      # close socket
      close

      # Reraise xml malformed exception
      raise XMLMalformedError, e.message
    rescue Errno::ECONNRESET => e
      # Close socket
      close

      # Reraise econreset! (server close connection, network failure etc..)
      raise e
    rescue => e
      # Close socket
      close

      # Reraise exception
      raise ConnectionFailed, e.message
    end

    # Send start stream to new connection.
    def start_stream
      # Start stream init
      @start_stream_xmpp ||= Xmpp2s::Protocol::StartStream.new(@jid.domain)

      # Start pre-authorization server handshake
      send_data(@start_stream_xmpp)

      # Read data
      response = read_data(append: '</stream:stream>')

      # Check features
      unless (@features = response.xpath('//stream:features').first)
        # Close connection
        close

        # Fail with protocol error!
        fail ProtocolError, 'Expected features not found!'
      end

      # Convert features to string
      @features = @features.to_s
    end

    def bind_resource
      # Bind resource
      send_data(Xmpp2s::Protocol::BindResource.new(@jid.resource))

      # Read response
      response = read_data.to_s

      # Find JID
      group_data = response.match %r{<jid>(?<jid>.*)<\/jid>}

      # Test group data
      if !group_data || !(jid_data = group_data['jid']) || !jid_data.start_with?(@jid.full_jid)
        close
        fail ConnectionFailed, 'Bind was unsuccesfull'
      end

      # Return OK
      true
    end

    def register_session
      # Bind resource
      send_data(Xmpp2s::Protocol::Session.new(@jid.resource))

      # Read response
      response = read_data.to_s

      # Test group data
      unless response.include?('<session xmlns="urn:ietf:params:xml:ns:xmpp-session"/>')
        close
        fail ConnectionFailed, 'Registering session was unsuccesfull'
      end

      # Return OK
      true
    end

  end
end
