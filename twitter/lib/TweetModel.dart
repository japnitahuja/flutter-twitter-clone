import 'package:twitter/Tweet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';
import 'package:twitter/db_utils.dart';

class TweetModel {
  Future<int> insertTweet(Tweet tweet) async {
    final db = await DBUtils.init();
    return db.insert(
      'tweets',
      tweet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTweet(Tweet tweet) async {
    final db = await DBUtils.init();
    return db.update(
      'tweets',
      tweet.toMap(),
      where: 'tweetId = ?',
      whereArgs: [tweet.tweetId],
    );
  }

  Future<int> deleteTweet(Tweet tweet) async {
    final db = await DBUtils.init();
    return db.delete(
      'tweets',
      where: 'tweetId = ?',
      whereArgs: [tweet.tweetId],
    );
  }


  Future<List<Tweet>> getAllTweets() async {
    final db = await DBUtils.init();
    print(db);
    // await db.delete("tweets");
    // await db.execute("ALTER TABLE tweets ADD COLUMN isFavorited INTEGER DEFAULT 0;");
    // await db.execute("ALTER TABLE tweets ADD COLUMN  linkedTweetId INTEGER DEFAULT NULL;");
    final List<Map<String, dynamic>> maps = await db.query('tweets');
    List<Tweet> result = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        result.add(Tweet.fromMap(maps[i]));
      }
    }
    return result;
  }
}