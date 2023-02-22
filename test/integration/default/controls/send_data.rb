# frozen_string_literal: true

require 'json'

control 'raw_body' do
  title 'Verify httprb request raw body support'
  impact 0.5

  describe httprb('https://httpbin.org/post', method: 'POST', data: 'abc=def') do
    its('code') { should eq 200 }
    its('body') { should match(/"data": "abc=def"/) }
  end
end

control 'json' do
  title 'Verify httprb request JSON support'
  impact 0.5

  describe httprb('https://httpbin.org/post', method: 'POST', json: { 'foo' => 'bar' }) do
    its('code') { should eq 200 }
    its('body') { should match(/"data": "{\\"foo\\":\\"bar\\"}"/) }
  end

  describe JSON.parse(
    JSON.parse(httprb('https://httpbin.org/post', method: 'POST', json: { 'foo' => 'bar' }).body,
               { symbolize_names: false })['data'], { symbolize_names: false }
  ) do
    its(['foo']) { should cmp 'bar' }
  end
end
