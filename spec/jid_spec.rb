require 'spec_helper'

describe Xmpp2s::Jid do
  let(:valid_jid) { described_class.new('info@chattycrow.com/home') }

  it 'create valid jid instance' do
    expect(valid_jid.username).to eq('info')
    expect(valid_jid.domain).to eq('chattycrow.com')
    expect(valid_jid.resource).to eq('home')
  end

  it 'allow override domain and resource' do
    domain = 'test_domain'
    resource = 'test_resource'

    jid = described_class.new('info@chattycrow.com/home', domain, resource)

    expect(jid.username).to eq('info')
    expect(jid.domain).to eq(domain)
    expect(jid.resource).to eq(resource)
  end

  it 'raise error when domain is not specified' do
    expect { described_class.new('info@chattycrow.com', '') }.to raise_error(ArgumentError)
  end

  it 'only jid' do
    expect(valid_jid.jid).to eq('info@chattycrow.com')
  end
end
