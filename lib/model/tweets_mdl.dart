class TweetMdl {
  final int twtId;
  final int userId;
  final String username;
  final String displayName;
   String tweet;
  final String? image;
  final String timestamp;
  int likes;
  int retweets;
  final int qtweets;
  final int views;
  int bookmarks;
  final int commentCount;
  Interactions interactions;

  TweetMdl({
    required this.twtId,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.tweet,
    this.image,
    required this.timestamp,
    required this.likes,
    required this.retweets,
    required this.qtweets,
    required this.views,
    required this.bookmarks,
    required this.commentCount,
    required this.interactions,
  });

  factory TweetMdl.fromJson(Map<String, dynamic> json) {
    return TweetMdl(
      twtId: json['twtId'],
      userId: json['userId'],
      username: json['username'],
      displayName: json['displayName'],
      tweet: json['tweet'],
      image: json['image'],
      timestamp: json['timestamp'],
      likes: json['likes'],
      retweets: json['retweets'],
      qtweets: json['qtweets'],
      views: json['views'],
      bookmarks: json['bookmarks'],
      commentCount: json['commentCount'],
      interactions: Interactions.fromJson(json['interactions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'twtId': twtId,
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'tweet': tweet,
      'image': image,
      'timestamp': timestamp,
      'likes': likes,
      'retweets': retweets,
      'qtweets': qtweets,
      'views': views,
      'bookmarks': bookmarks,
      'commentCount': commentCount,
      'interactions': interactions.toJson(),
    };
  }
}

class Interactions {
  bool isLiked;
  bool isRetweeted;
  bool isBookmarked;

  Interactions({
    required this.isLiked,
    required this.isRetweeted,
    required this.isBookmarked,
  });

  factory Interactions.fromJson(Map<String, dynamic> json) {
    return Interactions(
      isLiked: json['isLiked'],
      isRetweeted: json['isRetweeted'],
      isBookmarked: json['isBookmarked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLiked': isLiked,
      'isRetweeted': isRetweeted,
      'isBookmarked': isBookmarked,
    };
  }
}
