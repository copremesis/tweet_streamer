IF you have NOT created a twitter app you can do so here:
[Create new twitter developer application](https://apps.twitter.com/app/new)
to get your twitter authentication 
Or if already have credentials this CLI will look for a file .env in your home folder in the fashion as:

```ruby
CONSUMER_KEY='****' 
CONSUMER_SECRET='****' 
ACCESS_TOKEN='****' 
ACCESS_SECRET='****' 

online support

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

example use

```bash
$ ruby tweet_streamer.rb -w 3 -d 3 --er 0.2 --dr 0.4
opening faucet for 3 seconds
BEGIN marshalling stream....
faucet window closed.
BEGIN un-mashalling & displaying stream results
{
          :tweet => "am i a loyal taehyung stan?",
       :datetime => "Thu Dec 31 20:01:34 +0000 2015",
           :user => "blesstkpop",
    :queue_index => 1
}
{
          :tweet => "ヲタ垢では\nかやちゅん かなちゅん ひおりん\nが暴れてて\n\n此処に今来たら\nはた の画像が溢れてた\n\n何みんな\n新年早々 深夜のテンション発動してるん ？ 笑",
       :datetime => "Thu Dec 31 20:01:34 +0000 2015",
           :user => "na_love_rainbow",
    :queue_index => 2
}
{
          :tweet => "RT @mindsconsale: Awkward Moments Which Can Make Anyone Feel Jealous...\n\nsee click here &gt;&gt;&gt; https://t.co/agYZQccRE7",
       :datetime => "Thu Dec 31 20:01:34 +0000 2015",
           :user => "its_funy_truth",
    :queue_index => 3
}
{
          :tweet => "RT @lespros_fumika: 眠さで幕張メッセを後にしたのに\n帰り道が寒すぎて眠気はいずこへ\nお風呂入ってみかん食べながら\nテレビみながら眠気待機ですな",
       :datetime => "Thu Dec 31 20:01:34 +0000 2015",
           :user => "nochi_match",
    :queue_index => 4
}
```
