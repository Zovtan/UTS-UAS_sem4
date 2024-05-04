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
        userId: 165,
        username: "@shampoo",
        displayName: "John Shamos",
        tweet: "THEY JUST HUNTED MY FAMILY",
        image: "assets/images/image1.jpeg",
        timestamp: "2024-05-04T08:00:00Z",
        likes: 100,
        retweets: 50,
        qtweets: 10,
        views: 230,
        bookmarks: 5),
    Tweet(
        twtId: 2,
        userId: 166,
        username: "@thebestemployee",
        displayName: "Mission Control",
        tweet: "Can't believe the last batch of new recruits fell into a deep pit",
        image: "none",
        timestamp: "2024-05-03T10:30:00Z",
        likes: 200,
        retweets: 75,
        qtweets: 10,
        views: 579,
        bookmarks: 7),
    Tweet(
        twtId: 3,
        userId: 167,
        username: "@trendieteen",
        displayName: "Popular Pepino",
        tweet:
            "They got Jacob!",
        image: "assets/images/image2.png",
        timestamp: "2024-05-03T15:45:00Z",
        likes: 150,
        retweets: 30,
        qtweets: 10,
        views: 611,
        bookmarks: 10),
    Tweet(
        twtId: 4,
        userId: 168,
        username: "@wanderingmonk",
        displayName: "Mikudrin",
        tweet:
            "I look sooo good 💅💅💅",
        image: "assets/images/image3.png",
        timestamp: "2024-05-04T12:15:00Z",
        likes: 300,
        retweets: 100,
        qtweets: 10,
        views: 1002,
        bookmarks: 7),
    Tweet(
        twtId: 5,
        userId: 169,
        username: "@thebraveknight",
        displayName: "Lil Gator",
        tweet: "Took me an hour to climb up here",
        image: "assets/images/image4.png",
        timestamp: "2024-05-02T20:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 444,
        bookmarks: 1),
    Tweet(
        twtId: 6,
        userId: 170,
        username: "@judgementkazzy",
        displayName: "Uncle Kaz",
        tweet:
            "What have I run into this time...",
        image: "assets/images/image5.png",
        timestamp: "2024-05-01T20:00:00Z",
        likes: 6900,
        retweets: 980,
        qtweets: 40,
        views: 75632,
        bookmarks: 88),
    Tweet(
        twtId: 7,
        userId: 171,
        username: "@thechosenundead",
        displayName: "Local Knight",
        tweet:
            "...",
        image: "none",
        timestamp: "2024-05-04T20:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 300,
        bookmarks: 90),
        Tweet(
        twtId: 8,
        userId: 172,
        username: "@dungeondwelver",
        displayName: "Senshi",
        tweet:
            "Cooked a good bunch of treasure bugs",
        image: "assets/images/image6.jpg",
        timestamp: "2024-05-04T22:00:00Z",
        likes: 250,
        retweets: 80,
        qtweets: 10,
        views: 300,
        bookmarks: 90),
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
