import 'dart:math';

import 'package:flutter/material.dart';
import 'package:twitter/CreateCommentPage.dart';
import 'CreateTweetPage.dart';
import 'Tweet.dart';
import 'TweetModel.dart';

class TweetWidget extends StatefulWidget {
  final Tweet tweet;
  final Function() loadTweets;

  TweetWidget({
    required this.tweet,
    required this.loadTweets
  });

  String calculateTimeInHours() {
    DateTime tweetTimestamp = DateTime.parse(tweet.timeString!);
    DateTime now = DateTime.now();
    Duration difference = now.difference(tweetTimestamp);
    int hoursDifference = difference.inHours;
    return '$hoursDifference h';
  }

  @override
  _TweetWidgetState createState() => _TweetWidgetState();
}


class _TweetWidgetState extends State<TweetWidget> {

  void showHideTweetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hide Tweet"),
          content: Text("Do you want to hide this tweet?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                TweetModel tweetModel = TweetModel();
                await tweetModel.deleteTweet(widget.tweet);
                await widget.loadTweets();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Hide"),
            ),
          ],
        );
      },
    );
  }

  String generateRandomDefaultImg(){
    return 'https://picsum.photos/seed/${widget.tweet.tweetId}/200/300';
  }

  @override
  Widget build(BuildContext context) {

    bool isLiked = widget.tweet.numLikes! == 1;
    bool isRetweeted = widget.tweet.numRetweets! == 1;
    bool isFavorited = widget.tweet.isFavorited! == 1;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Column: User Avatar
          CircleAvatar(
            backgroundImage: NetworkImage(generateRandomDefaultImg()),
            radius: 30.0,
          ),
          SizedBox(width: 16.0),
          // Second Column: Tweet Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.tweet.userLongName!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      "@" + widget.tweet.userShortName!,
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                    Text(
                      widget.calculateTimeInHours(),
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.expand_more),
                      onPressed: () {
                        showHideTweetDialog(); // Show the dialog when the button is clicked
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.tweet.description!,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(height: 8.0),
                // Conditionally show the image only if it exists
                if (widget.tweet.imageURL != null && widget.tweet.imageURL!.isNotEmpty)
                  Image.network(
                    widget.tweet.imageURL!,
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chat_bubble_outline),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateCommentPage(tweet: widget.tweet),
                              ),
                            ).then((value) {
                              if (value == true) {
                                // Reload tweets if a new tweet is created
                                widget.loadTweets();
                              }
                            });
                          },
                        ),
                        Text('${widget.tweet.numComments}'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isRetweeted ? Icons.repeat : Icons.repeat,
                            color: isRetweeted ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            // Toggle like state
                            setState(() {
                              isRetweeted = !isRetweeted;
                              // Update like count in the tweet object
                              widget.tweet.numRetweets = widget.tweet.numRetweets!
                                  + (isRetweeted? 1 : -1);
                            });
                            TweetModel tweetModel = TweetModel();
                            await tweetModel.updateTweet(widget.tweet);
                          },
                        ),
                        Text('${widget.tweet.numRetweets}'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            // Toggle like state
                            setState(() {
                              isLiked = !isLiked;
                              // Update like count in the tweet object
                              widget.tweet.numLikes = widget.tweet.numLikes!
                                  + (isLiked? 1 : -1);
                            });
                            TweetModel tweetModel = TweetModel();
                            await tweetModel.updateTweet(widget.tweet);
                          },
                        ),
                        Text('${widget.tweet.numLikes}'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorited ? Icons.bookmark : Icons.bookmark_border,
                            color: isFavorited ? Colors.blueAccent : Colors.grey,
                          ),
                          onPressed: () async {
                            // Toggle like state
                            setState(() {
                              isFavorited = !isFavorited;
                              // Update like count in the tweet object
                              widget.tweet.isFavorited = widget.tweet.isFavorited!
                                  + (isFavorited? 1 : -1);
                            });
                            TweetModel tweetModel = TweetModel();
                            await tweetModel.updateTweet(widget.tweet);
                            widget.loadTweets();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
