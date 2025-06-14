# frozen_string_literal: true

control 'tls-1.0-default' do
  title 'Verify httprb against TLS 1.0 server with default options should fail'
  impact 0.8

  describe begin
    _ = httprb('https://tls-v1-0.badssl.com:1010/').body
    false
  rescue StandardError
    true
  end do
    it { should cmp true }
  end
end

control 'tls-1.0-no-verify' do
  title 'Verify httprb against TLS 1.0 server with verify disabled should fail'
  impact 0.8

  describe begin
    _ = httprb('https://tls-v1-0.badssl.com:1010/').body
    false
  rescue StandardError
    true
  end do
    it { should cmp true }
  end
end

control 'tls-1.1-default' do
  title 'Verify httprb against TLS 1.1 server with default options should fail'
  impact 0.8

  describe begin
    _ = httprb('https://tls-v1-1.badssl.com:1010/').body
    false
  rescue StandardError
    true
  end do
    it { should cmp true }
  end
end

control 'tls-1.1-no-verify' do
  title 'Verify httprb against TLS 1.1 server with verify disabled should fail'
  impact 0.8

  describe begin
    _ = httprb('https://tls-v1-1.badssl.com:1010/').body
    false
  rescue StandardError
    true
  end do
    it { should cmp true }
  end
end

control 'tls-1.2-default' do
  title 'Verify httprb against TLS 1.2 server with default options'
  impact 0.8

  describe httprb('https://tls-v1-2.badssl.com:1012/', ssl_verify: false) do
    its('status') { should eq 200 }
  end
end

control 'tls-1.2-no-verify' do
  title 'Verify httprb against TLS 1.2 server with verify disabled'
  impact 0.8

  describe httprb('https://tls-v1-2.badssl.com:1012/', ssl_verify: false) do
    its('status') { should eq 200 }
  end
end

control 'expired-cert-default' do
  title 'Verify httprb against server with expired certificate'
  impact 0.8

  describe begin
    _ = httprb('https://expired.badssl.com/').body
    false
  rescue StandardError
    true
  end do
    it { should cmp true }
  end
end

control 'expired-cert-no-verify' do
  title 'Verify httprb against server with expired certificate and verify disabled'
  impact 0.8

  describe httprb('https://expired.badssl.com/', ssl_verify: false) do
    its('status') { should eq 200 }
  end
end

control 'self-signed-cert-default' do
  title 'Verify httprb against server with self-signed certificate'
  impact 0.8

  describe begin
    _ = httprb('https://self-signed.badssl.com/').body
    false
  rescue StandardError
    true
  end do
    it { should cmp true }
  end
end

control 'self-signed-cert-no-verify' do
  title 'Verify httprb against server with self-signed certificate and verify disabled'
  impact 0.8

  describe httprb('https://self-signed.badssl.com/', ssl_verify: false) do
    its('status') { should eq 200 }
  end
end

control 'wrong-host-cert-default' do
  title 'Verify httprb against server with incorrect host certificate'
  impact 0.8

  describe begin
    _ = httprb('https://wrong.host.badssl.com/').body
    false
  rescue StandardError
    true
  end do
    it { should cmp true }
  end
end

control 'wrong-host-cert-no-verify' do
  title 'Verify httprb against server with incorrect host certificate and verify disabled'
  impact 0.8

  describe httprb('https://wrong.host.badssl.com/', ssl_verify: false) do
    its('status') { should eq 200 }
  end
end
