# frozen_string_literal: true

require 'http'
require 'inspec/resources/http'

# Implements an HTTP client that acts like Inspec http resource, but uses HTTPrb
# as the client.
class HTTPClient < Inspec.resource(1)
  name 'httprb'
  desc <<-_DESCRIPTION_
  Provides an httprb resource with sane TLS defaults that has similar API to InSpec
  http, but with options for TLS parameters, HTTP/2 headers, etc.
  _DESCRIPTION_
  example <<-_EXAMPLE_
  describe httprb(url) do
    its('status') { should eq 200 }
    its('headers.Content-Type') { should cmp 'text/html' }
  end

  describe httprb(url, method: :HEAD, ssl: { ca_file: '/path/to/ca.pem' }) do
    its('status') { should eq 204 }
    its('body') { should be_empty }
  end
  _EXAMPLE_
  supports platform: 'unix'

  attr_reader :url, :opts

  # rubocop: disable Lint/MissingSuper
  def initialize(url, opts = {})
    @url = url
    @opts = opts
    @response = nil
  end
  # rubocop: enable Lint/MissingSuper

  def resource_id
    id = Digest::SHA2.new << @url << @get
    super(id.hexdigest)
  end

  def code
    response.code
  end

  def headers
    @headers ||= Inspec::Resources::Http::Headers.create(response.headers)
  end

  def body
    @body ||= response.body.to_s
  end

  def to_s
    if @opts && @url
      "HTTP #{method} on #{@url}"
    else
      'HTTP Resource'
    end
  end

  # Start: InSpec http methods
  alias status code

  def http_method
    method.to_s.upcase
  end
  # End: InSpec http methods

  private

  def method
    opts.fetch(:method, :GET)
  end

  def ssl
    return { verify_mode: OpenSSL::SSL::VERIFY_NONE, min_version: nil } unless opts.fetch(:ssl_verify, true)

    opts.fetch(:ssl, { verify_mode: OpenSSL::SSL::VERIFY_PEER, min_version: OpenSSL::SSL::TLS1_2_VERSION })
  end

  def request_headers
    opts.fetch(:headers, {})
  end

  def params
    opts.fetch(:params, {})
  end

  def request_body
    opts.fetch(:body, opts.fetch(:data, nil))
  end

  def json
    opts.fetch(:json, nil)
  end

  def form
    opts.fetch(:form, nil)
  end

  def auth(client)
    auth = opts.fetch(:auth, {})
    if auth[:user] && auth[:pass]
      client.basic_auth(user: auth[:user], pass: auth[:pass])
    elsif auth[:token]
      client.auth("Bearer #{auth[:token]}")
    else
      client
    end
  end

  # TODO: @memes - avoided so far, but will need to add it for private GKE testing, etc
  def proxy
    {}
  end

  def timeout
    {
      connect: @opts.fetch(:open_timeout, nil),
      read: @opts.fetch(:read_timeout, nil)
    }.select { |_, v| v && !v.to_s.empty? }
  end

  def response
    return @response if @response

    client = auth(HTTP::Client.new({ proxy: proxy, timeout_options: timeout, ssl: ssl }).headers(request_headers))
    @response = client.request(method, url, { params: params, body: request_body, json: json, form: form })
  end
end
