IF you have NOT created a twitter app you can do so here:
[Create new twitter developer application](https://apps.twitter.com/app/new)
to get your twitter authentication 
Or if already have credentials this CLI will look for a file .env in your home folder in the fashion as:

```ruby
CONSUMER_KEY='****' 
CONSUMER_SECRET='****' 
ACCESS_TOKEN='****' 
ACCESS_SECRET='****' 
```



```bash
ruby tweet_streamer.rb
Usage: tweet_streamer [options]
    -w, --window SECONDS
    -d, --delay SECONDS
        --er, --enqueue_rate  0 < x < 1
        --dr, --dequeue_rate  0 < x < 1
    -e, --endpoint URL
EXAMPLE: ruby tweet_streamer.rb -w 3 -d 3 --er 0.2 --dr 0.4
```
