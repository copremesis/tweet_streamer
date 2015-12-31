
class Main
  def initialize
    @threads = []
    @queue = []
    @options = {}
    parse_options(ARGV) 

    #defaults
    @marshal_delay = @options[:delay] || 3
    @marshal_rate =  @options[:enqueue_rate] || 0.2
    @unmarshal_delay = @options[:delay] || 3
    @unmarshal_rate =  @options[:dequeue_rate] || 0.4
    @stream_temp_file = @options[:tmp_file] || '/tmp/tweet_stream'

    #status
    @stats = {:faucet_opened_at => Time.now.to_s}.merge(@options)

  end

  def parse_options(argv)
    options = OptionParser.new
    options.on("-w", "--window SECONDS") { |v| @options[:faucet_window] = (v || 10).to_i}
    options.on("-d", "--delay SECONDS") { |v| @options[:delay] = (v || 3).to_i}
    options.on("--er", "--enqueue_rate  0 < x < 1") { |v| @options[:enqueue_rate] = (v || 0.2).to_f}
    options.on("--dr", "--dequeue_rate  0 < x < 1") { |v| @options[:dequeue_rate] = (v || 0.4).to_f}
    options.on("-e", "--endpoint URL") { |v| @options[:url] = v || 'https://stream.twitter.com/1.1/statuses/sample.json'}
    
    if(argv.size == 0) 
      puts options.to_s
      puts "EXAMPLE: ruby tweet_streamer.rb -w 3 -d 3 --er 0.2 --dr 0.4"
      exit 1
    end
    options.parse(*argv)
  end

  def run
    open_faucet
    marshal 
    unmarshal
    @threads.map(&:join)
  end

  private

  def open_faucet
    @threads << Thread.new do #put
      header = OAuthSignature.new.oauth_header
      ts = TweetStreamer.new(header, @options)
      ts.get_stream
    end
  end

  #* pause to allow some buffering to occur default 3 seconds
  #* read file in chunks
  #* parse tweet ignoring noise
  #* transform hash object into class object using OpenStruct 
  #* push onto @queue for transport further crunching processing

  def marshal
    sleep @marshal_delay #pause before Q-ing/mashalling and displaying blurb
    @threads << Thread.new do 
      puts 'BEGIN marshalling stream....'
      IO.foreach(@stream_temp_file) {|line|
        
        if(tweet = TweetParser.parse(line))
          unless tweet.keys.include? 'delete' 
            tweet['queue_index'] = @queue.size + 1
            tweet_as_class_object = OpenStruct.new(tweet) #transform tweet to class instance
            @queue << Marshal.dump(tweet_as_class_object) 
          end
          sleep @marshal_rate #race condition based on interval of stream parsing
        end
      }
      puts "END marshalling stream....#tweets: #{@queue.size}"
      @stats[:number_of_tweets_collected] = @queue.size
    end
  end

  #simililarly to mashal a bit of lag aka buffering will allow the queue to fill up before processing
  #ideally I'd use redis & resque for this yet for this exercise a delay is passed via command line 
  #delay default is 5 seconds
  #rate of dequeuing is 0.4 seconds 

  def unmarshal
    sleep @unmarshal_delay 
    @threads << Thread.new do
      puts 'BEGIN un-mashalling & displaying stream results'
      @queue.each {|marshalled_tweet|
        sleep @unmarshal_rate #race condition based on interval of stream parsing
        tweet = Marshal.load(marshalled_tweet)
        scrape = { 
          :tweet       => tweet.text,
          :datetime    => tweet.created_at,
          :user        => tweet.user['screen_name'],
          :queue_index => tweet.queue_index
        }
        ap scrape rescue (puts JSON.pretty_generate(scrape))
        @stats[:number_of_tweets_displayed] = @stats[:number_of_tweets_displayed] || 0
        @stats[:number_of_tweets_displayed] += 1
      }
      puts "END un-marshalling queue process #{@queue.size}"
      @stats[:tweet_capture_display_ratio] = @stats[:number_of_tweets_collected]/@stats[:number_of_tweets_displayed].to_f 
      ap @stats rescue (puts JSON.pretty_generate(@stats))
      
    end
  end
end
