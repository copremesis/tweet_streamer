
class OAuthSignature
  def initialize
    @timestamp = Time.now.to_i 
    @nonce = SecureRandom.base64(42).gsub(/\W/, '')[0,32]
    @oauth_signature = build_oath_signature()
  end

  def oauth_header
    oauth = {
      :oauth_consumer_key => CONSUMER_KEY, 
      :oauth_nonce => @nonce,
      :oauth_signature => @oauth_signature,
      :oauth_signature_method  => 'HMAC-SHA1',
      :oauth_timestamp => @timestamp,
      :oauth_token => ACCESS_TOKEN,
      :oauth_version => '1.0'
    }
    auth_header = "Authorization: OAuth " + oauth.map {|k,v|
     [k,'="', v, '"'].join('')
    }.join(', ')
  end

  #test stream by generating cURL statement
  
  def cURL
    "curl --get 'https://stream.twitter.com/1.1/statuses/sample.json' --header '#{oauth_header}' --verbose end"
  end

  private
  
  def collecting_parameters
    ["oauth_consumer_key=#{CONSUMER_KEY}",
     "oauth_nonce=#{@nonce}",
     "oauth_signature_method=HMAC-SHA1",
     "oauth_timestamp=#{@timestamp}",
     "oauth_token=#{ACCESS_TOKEN}",
     "oauth_version=1.0"].join("&")
  end

  def build_oath_signature
      signature_build = {
        :signature_base_string => ["GET", CGI::escape("https://stream.twitter.com/1.1/statuses/sample.json"), CGI::escape(collecting_parameters)].join('&'),
        :signing_key => [CONSUMER_SECRET, ACCESS_SECRET].map{|cred| CGI::escape(cred)}.join('&')
      }
      oauth_signature = CGI::escape(["#{OpenSSL::HMAC.digest('sha1', signature_build[:signing_key], signature_build[:signature_base_string])}"].pack("m").chomp)
  end
end
