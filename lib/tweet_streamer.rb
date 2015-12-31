class TweetStreamer

  def initialize(auth_header, options = {})
    @endpoint = options[:url] || 'https://stream.twitter.com/1.1/statuses/sample.json' #default stream api url
    @uri = URI.parse(@endpoint)
    @header =  make_hash_header(auth_header.strip)
    @stream_temp_file = options[:tmp_file] || '/tmp/tweet_stream'
    @faucet_window = options[:faucet_window] || 10
  end

  def get_stream
    puts "opening faucet for #{@faucet_window} seconds"
    Timeout::timeout(@faucet_window) {
      infinite_stream
    }
  rescue => e
    puts 'faucet window closed.'
  end

  private

  def make_hash_header(h)
    k, v = h.split(/:/)
    {k => v}
  end

  ###copied directly out of Net::HTTP lib###
  #http://ruby-doc.org/stdlib-2.3.0/libdoc/net/http/rdoc/Net/HTTP.html#class-Net::HTTP-label-Streaming+Response+Bodies
  #combined with
  #http://ruby-doc.org/stdlib-2.3.0/libdoc/net/http/rdoc/Net/HTTP.html#class-Net::HTTP-label-HTTPS

  def infinite_stream
    Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new @uri
      request['Authorization'] = @header['Authorization'] #applying authentication header obtained by user
      http.request request do |response|
        open @stream_temp_file, 'w' do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end
end
