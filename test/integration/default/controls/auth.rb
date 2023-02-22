# frozen_string_literal: true

control 'basic-auth-no-creds' do
  title 'Verify httprb basic auth support with missing creds'
  impact 0.5

  user = 'foo'
  password = 'bar'

  describe httprb("https://httpbin.org/basic-auth/#{user}/#{password}") do
    its('code') { should eq 401 }
  end
end

control 'basic-auth' do
  title 'Verify httprb basic auth support'
  impact 0.5

  user = 'foo'
  password = 'bar'

  describe httprb("https://httpbin.org/basic-auth/#{user}/#{password}", auth: { user: user, pass: password }) do
    its('code') { should eq 200 }
  end
end

control 'bearer-no-creds' do
  title 'Verify httprb bearer token support with missing creds'
  impact 0.5

  describe httprb('https://httpbin.org/bearer') do
    its('code') { should eq 401 }
  end
end

control 'bearer' do
  title 'Verify httprb bearer token support'
  impact 0.5

  describe httprb('https://httpbin.org/bearer', auth: { token: 'foobar' }) do
    its('code') { should eq 200 }
  end
end
