import 'package:flutter/material.dart';
import 'CreateTweetPage.dart';
import 'Tweet.dart';
import 'TweetList.dart';
import 'TweetModel.dart';

class MyTwitterPage extends StatefulWidget {
  @override
  _MyTwitterPageState createState() => _MyTwitterPageState();
}

class _MyTwitterPageState extends State<MyTwitterPage> {
  List<Tweet> tweets = [];
  String searchTerm = '';
  bool isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    loadTweets();
  }

  Future<void> loadTweets() async {
    TweetModel tweetModel = TweetModel();
    List<Tweet> loadedTweets = await tweetModel.getAllTweets();

    if(isSearchBarVisible){
      loadedTweets = getFilteredTweets(loadedTweets);
    }

    List<Tweet> favoritedTweets = [];
    List<Tweet> nonFavoritedTweets = [];

    for (var tweet in loadedTweets) {
      if (tweet.linkedTweetId == null){
        if (tweet.isFavorited == 1 ) {
          favoritedTweets.add(tweet);
        } else {
          nonFavoritedTweets.add(tweet);
        }
      }

    }

    List<Tweet> nonCommentTweets = [...favoritedTweets, ...nonFavoritedTweets];
    List<Tweet> comments = [];

    // Split tweets and comments based on linkedTweetId
    for (var tweet in loadedTweets) {
      if (tweet.linkedTweetId != null) {
        comments.add(tweet);
      }
    }

    // Insert comments after their linked tweets in the tweets list
    for (var comment in comments) {
      print("comment: $comment");
      int index = nonCommentTweets.indexWhere((tweet) => tweet.tweetId == comment.linkedTweetId);
      if (index != -1) {
        nonCommentTweets.insert(index + 1, comment);
      }
    }

    setState(() {
      this.tweets = nonCommentTweets;
    });
  }

  void onSearchChanged(String value) {
    setState(() {
      searchTerm = value;
    });
    loadTweets();
  }

  void toggleSearchBar() {
    setState(() {
      isSearchBarVisible = !isSearchBarVisible;
      if (!isSearchBarVisible) {
        searchTerm = '';
      }
    });
    loadTweets();
  }

  List<Tweet> getFilteredTweets(List<Tweet> tweets) {
    return tweets.where((tweet) {
      // You can customize this logic based on your search requirements
      return tweet.description!.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchBarVisible
            ? TextField(
          onChanged: onSearchChanged,
            style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search tweets...',
              hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        )
            : Text('My Twitter Page'),
        actions: [
          IconButton(
            icon: Icon(isSearchBarVisible ? Icons.close : Icons.search),
            onPressed: toggleSearchBar,
          ),
          if (!isSearchBarVisible)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTweetPage(),
                ),
              ).then((value) {
                if (value == true) {
                  // Reload tweets if a new tweet is created
                  loadTweets();
                }
              });
            },
          ),
        ],
      ),
      body: TweetList(tweets: tweets, loadTweets: loadTweets),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: MyTwitterPage(),
  ));
}
