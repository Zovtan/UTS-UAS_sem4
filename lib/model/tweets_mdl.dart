class TweetMdl {
  final int twtId;
  final int userId;
  final String username;
  final String displayName;
  final String tweet;
  final String image;
  final String timestamp;
  final int likes;
  final int retweets;
  final int qtweets;
  final int views;
  final int bookmarks;
  final int commentCount;
  final bool isLiked;
  final bool isRetweeted;
  final bool isBookmarked;

  TweetMdl({
    required this.twtId,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.tweet,
    required this.image,
    required this.timestamp,
    required this.likes,
    required this.retweets,
    required this.qtweets,
    required this.views,
    required this.bookmarks,
    required this.commentCount,
    this.isLiked = false,
    this.isRetweeted = false,
    this.isBookmarked = false,
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
      isLiked: json['isLiked'],
      isRetweeted: json['isRetweeted'],
      isBookmarked: json['isBookmarked'],
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
      'isLiked': isLiked,
      'isRetweeted': isRetweeted,
      'isBookmarked': isBookmarked,
    };
  }
}
