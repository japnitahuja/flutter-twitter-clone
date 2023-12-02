import 'package:flutter/material.dart';

import 'Tweet.dart';
import 'TweetModel.dart';

class CreateCommentPage extends StatefulWidget {
  final Tweet tweet;

  CreateCommentPage({
    required this.tweet
  });

  @override
  _CreateCommentPageState createState() => _CreateCommentPageState();
}

class _CreateCommentPageState extends State<CreateCommentPage> {
  TextEditingController userShortNameController = TextEditingController();
  TextEditingController userLongNameController = TextEditingController();
  TextEditingController tweetTextController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: userShortNameController,
              decoration: InputDecoration(labelText: 'User Short Name'),
            ),
            TextField(
              controller: userLongNameController,
              decoration: InputDecoration(labelText: 'User Long Name'),
            ),
            TextField(
              controller: tweetTextController,
              decoration: InputDecoration(labelText: 'Tweet Text'),
              maxLines: 3,
            ),
            TextField(
              controller: imageURLController,
              decoration: InputDecoration(labelText: 'Image URL (Optional)'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                Tweet newTweet = Tweet(
                  tweetId: DateTime.now().millisecondsSinceEpoch, // Assuming tweetId is auto-incremented in the database
                  linkedTweetId: widget.tweet.tweetId,
                  userShortName: userShortNameController.text,
                  userLongName: userLongNameController.text,
                  timeString: DateTime.now().toString(),
                  description: tweetTextController.text,
                  imageURL: imageURLController.text,
                  numComments: 0,
                  numRetweets: 0,
                  numLikes: 0,
                );

                widget.tweet.numComments = widget.tweet.numComments! + 1;

                TweetModel tweetModel = TweetModel();
                await tweetModel.insertTweet(newTweet);
                await tweetModel.updateTweet(widget.tweet);

                // Notify the previous page that a new tweet is created
                Navigator.pop(context, true);
              },
              child: Text('Create Tweet'),
            ),
          ],
        ),
      ),
    );
  }
}