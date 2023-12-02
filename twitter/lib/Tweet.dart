class Tweet {
  late int tweetId;
  int? linkedTweetId;
  String? userShortName;
  String? userLongName;
  String? timeString;
  String? description;
  String? imageURL;
  int? numComments;
  int? numRetweets;
  int? numLikes;
  int? isFavorited;

  Tweet({
    required this.tweetId,
    this.linkedTweetId,
    this.userShortName,
    this.userLongName,
    this.timeString,
    this.description,
    this.imageURL,
    this.numComments,
    this.numRetweets,
    this.numLikes,
    this.isFavorited,
  });

  @override
  String toString() {
    return 'Tweet{userShortName: $userShortName, userLongName: $userLongName, '
        'timeString: $timeString, description: $description, imageURL: $imageURL, '
        'numComments: $numComments, numRetweets: $numRetweets, numLikes: $numLikes}';
  }

  Tweet.fromMap(Map map) {
    tweetId = map["tweetId"];
    linkedTweetId = map['linkedTweetId'] ?? null;
    userShortName = map['userShortName'] ?? '';
    userLongName = map['userLongName'] ?? '';
    timeString = map['timeString'] ?? '';
    description = map['description'] ?? '';
    imageURL = map['imageURL'] ?? '';
    numComments = map['numComments'] ?? 0;
    numRetweets = map['numRetweets'] ?? 0;
    numLikes = map['numLikes'] ?? 0;
    isFavorited = map['isFavorited'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'tweetId': tweetId,
      'linkedTweetId': linkedTweetId,
      'userShortName': userShortName,
      'userLongName': userLongName,
      'timeString': timeString,
      'description': description,
      'imageURL': imageURL,
      'numComments': numComments,
      'numRetweets': numRetweets,
      'numLikes': numLikes,
      'isFavorited': isFavorited,
    };
  }
}

