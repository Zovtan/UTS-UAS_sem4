class Tweet {
  int twtId;
  int userId;
  String username;
  String displayName;
  String tweet;
  String image;
  String timestamp;
  int likes;
  int retweets;
  int qtweets;
  int views;
  int bookmarks;
  int commentCount;
  bool isLiked;
  bool isRetweeted;
  bool isBookmarked;

  Tweet({
    required this.twtId,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.tweet,
    required this.qtweets,
    required this.image,
    required this.timestamp,
    required this.likes,
    required this.retweets,
    required this.views,
    required this.bookmarks,
    this.isLiked = false,
    this.isRetweeted = false,
    this.isBookmarked = false,
    this.commentCount = 0,
  });
}

class TweetData {
  List<Tweet> tweets = [
    Tweet(
        twtId: 1,
        userId: 65,
        username: "@JohnDoe",
        displayName: "johndoe",
        tweet: "Just had a fantastic day exploring the city! #travel",
        image: "assets/images/image1.jpg",
        timestamp: "2024-05-01T08:00:00Z",
        likes: 100,
        retweets: 50,
        qtweets: 10,
        views: 230,
        bookmarks: 5),
    Tweet(
        twtId: 2,
        userId: 66,
        username: "@JaneSmith",
        displayName: "janesmith",
        tweet: "Excited to announce my new blog post! Check it out: [link]",
        image: "none",
        timestamp: "2024-04-24T10:30:00Z",
        likes: 200,
        retweets: 75,
        qtweets: 10,
        views: 579,
        bookmarks: 7),
    Tweet(
        twtId: 3,
        userId: 67,
        username: "@TechGeek",
        displayName: "techgeek",
        tweet:
            "Just received the latest tech gadget! Can't wait to try it out.",
        image: "none",
        timestamp: "2024-04-23T15:45:00Z",
        likes: 150,
        retweets: 30,
        qtweets: 10,
        views: 611,
        bookmarks: 10),
    Tweet(
        twtId: 4,
        userId: 68,
        username: "@Foodie",
        displayName: "@foodie",
        tweet:
            "Enjoying a delicious meal at my favorite restaurant! #foodlover",
        image: "none",
        timestamp: "2024-04-22T12:15:00Z",
        likes: 300,
        retweets: 100,
        qtweets: 10,
        views: 1002,
        bookmarks: 7),
    Tweet(
        twtId: 5,
        userId: 69,
        username: "@SportsFan",
        displayName: "sportsfan",
        tweet: "What a game last night! Can't believe the comeback victory!",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 444,
        bookmarks: 1),
    Tweet(
        twtId: 6,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet:
            "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 571,
        bookmarks: 0),
    Tweet(
        twtId: 7,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet:
            "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 300,
        bookmarks: 90),
    Tweet(
        twtId: 8,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet:
            "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 1560,
        bookmarks: 5),
    Tweet(
        twtId: 9,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet:
            "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 7000,
        bookmarks: 5),
    Tweet(
        twtId: 10,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet: "#",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 7000,
        bookmarks: 5),
  ];

  void addTweet(Tweet tweet) {
    tweets.insert(0,
        tweet); // supaya saat tweet baru ditambah, akan diletakkan di paling atas
  }

  void updateTweet(Tweet editedTweet) {
    int index = tweets.indexWhere((tweet) => tweet.twtId == editedTweet.twtId);
    if (index != -1) {
      tweets[index] = editedTweet;
    }
  }

  void deleteTweet(int targetTweetId) {
    tweets.removeWhere((tweet) => tweet.twtId == targetTweetId);
  }
}
