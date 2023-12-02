import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBUtils{
  static Future init() async {
    getDatabasesPath().then( (value) => print(value) );
    var database = openDatabase(
        path.join(await getDatabasesPath(), 'tweets.db'),
        onCreate: (db,version) {
         db.execute('CREATE TABLE tweets('
              'tweetId INTEGER PRIMARY KEY,'
              'linkedTweetId INTEGER,'
              'userShortName TEXT, '
              'userLongName TEXT, '
              'timeString TEXT, '
              'description TEXT, '
              'imageURL TEXT, '
              'numComments INTEGER, '
              'numRetweets INTEGER, '
              'numLikes INTEGER,'
              'isFavorited INTEGER)');
        },
        version: 3
    );
    print("Created db $database");
    return database;
  }

}