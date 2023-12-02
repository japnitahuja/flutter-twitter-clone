import 'package:flutter/material.dart';
import 'package:twitter/TweetWidget.dart';

import 'Tweet.dart';

class TweetList extends StatelessWidget {
  final List<Tweet> tweets;
  final Function() loadTweets;

  TweetList({
    required this.tweets,
    required this.loadTweets
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(tweets.length, (index) {
        // Use placeholder data for all tweets
        return TweetWidget(tweet: tweets[index], loadTweets: loadTweets,);
      }),
    );
  }
}