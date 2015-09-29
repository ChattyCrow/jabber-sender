# Xmpp2s - Xmpp Send Message

This gem is not a fully replacement for xmpp4r gem! You can use this gem
just only to simple send a jabber message. This gem is based on xmpp4r
and jabber4r versions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xmpp2s'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xmpp2s

## Usage

```ruby
  session = Xmpp2s::Session.open('account@host/resource', 'password')
  session.send_message('jack@jabber.org', 'Test message')
  session.close
```

## Contributing

1. Fork it ( https://github.com/ChattyCrow/xmpp2s/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
