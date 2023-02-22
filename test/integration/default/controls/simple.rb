# frozen_string_literal: true

control 'methods' do
  title 'Verify httprb method support'
  impact 0.5

  %i[delete get patch post put patch].each do |method|
    url = "https://httpbin.org/#{method.to_s.downcase}"
    describe httprb(url, method: method) do
      its('code') { should eq 200 }
      its('body') { should_not be_empty }
      its('body') { should match(/"url": "#{url}"/) }
      its('headers.Content-Type') { should match(%r{application/json}) }
      its('headers.Server') { should match(/gunicorn/) }
    end
  end
end

control 'headers' do
  title 'Verify httprb header support'
  impact 0.5

  describe httprb('https://httpbin.org/get', headers: { 'X-Simple-Test' => 'xYz' }) do
    its('code') { should eq 200 }
    its('body') { should match(/"headers": {[^}]*"X-Simple-Test": "xYz"/) }
  end
end

control 'parameters' do
  title 'Verify httprb parameter support'
  impact 0.5

  describe httprb('https://httpbin.org/get', params: { 'X-Simple-Test' => 'xYz' }) do
    its('code') { should eq 200 }
    its('body') { should match(%r{"url": "https://httpbin.org/get\?X-Simple-Test=xYz"}) }
  end
end
