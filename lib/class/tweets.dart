class Tweet {
  int id;
  int userId;
  String username;
  String displayName;
  String tweet;
  String image;
  String timestamp;
  int likes;
  int retweets;
  int views;
  int bookmarks;
  int commentCount;

  Tweet({
    required this.id,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.tweet,
    required this.image,
    required this.timestamp,
    required this.likes,
    required this.retweets,
    required this.views,
    required this.bookmarks,
    this.commentCount = 0,
  });
}

class TweetData {
  List<Tweet> tweets = [
    Tweet(
        id: 1,
        userId: 65,
        username: "@JohnDoe",
        displayName: "johndoe",
        tweet: "Just had a fantastic day exploring the city! #travel",
        image: "assets/images/image1.jpg",
        timestamp: "2024-05-01T08:00:00Z",
        likes: 100,
        retweets: 50,
        views: 230,
        bookmarks: 5),
    Tweet(
        id: 2,
        userId: 66,
        username: "@JaneSmith",
        displayName: "janesmith",
        tweet: "Excited to announce my new blog post! Check it out: [link]",
        image: "none",
        timestamp: "2024-04-24T10:30:00Z",
        likes: 200,
        retweets: 75,
        views: 579,
        bookmarks: 7),
    Tweet(
        id: 3,
        userId: 67,
        username: "@TechGeek",
        displayName: "techgeek",
        tweet:
            "Just received the latest tech gadget! Can't wait to try it out.",
        image: "none",
        timestamp: "2024-04-23T15:45:00Z",
        likes: 150,
        retweets: 30,
        views: 611,
        bookmarks: 10),
    Tweet(
        id: 4,
        userId: 68,
        username: "@Foodie",
        displayName: "@foodie",
        tweet:
            "Enjoying a delicious meal at my favorite restaurant! #foodlover",
        image: "none",
        timestamp: "2024-04-22T12:15:00Z",
        likes: 300,
        retweets: 100,
        views: 1002,
        bookmarks: 7),
    Tweet(
        id: 5,
        userId: 69,
        username: "@SportsFan",
        displayName: "sportsfan",
        tweet: "What a game last night! Can't believe the comeback victory!",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        views: 444,
        bookmarks: 1),
    Tweet(
        id: 6,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet:
            "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        views: 571,
        bookmarks: 0),
    Tweet(
        id: 7,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet:
            "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        views: 300,
        bookmarks: 90),
    Tweet(
        id: 8,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet:
            "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        views: 1560,
        bookmarks: 5),
    Tweet(
        id: 9,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet:
            "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        views: 7000,
        bookmarks: 5),
    Tweet(
        id: 10,
        userId: 70,
        username: "@test",
        displayName: "sbambino",
        tweet: "#",
        image: "none",
        timestamp: "2024-04-21T20:00:00Z",
        likes: 250,
        retweets: 80,
        views: 7000,
        bookmarks: 5),
  ];

  void addTweet(Tweet tweet) {
    tweets.insert(0,
        tweet); // supaya saat tweet baru ditambah, akan diletakkan di paling atas
  }

/*   void updateTweet(int index, Tweet tweet) {
    if (index >= 0 && index < tweets.length) {
      tweets[index] = tweet;
    }
  } */

  void updateTweet(Tweet editedTweet) {
    int index = tweets.indexWhere((tweet) => tweet.id == editedTweet.id);
    if (index != -1) {
      tweets[index] = editedTweet;
    }
  }

  void deleteTweet(int targetTweetId) {
    tweets.removeWhere((tweet) => tweet.id == targetTweetId);
  }
}

/* void main() {
  // Example usage:
  var jsonData = [
    {
      "id": 1,
      "username": "JohnDoe",
      "displayName": "@johndoe",
      "tweet": "Just had a fantastic day exploring the city! #travel",
      "image": "assets/images/image1.jpg",
      "timestamp": "2024-04-25T08:00:00Z",
      "likes": 100,
      "retweets": 50
    },
    // Additional tweets here...
  ];

  TweetData tweetData = TweetData.fromJsonList(jsonData);
  
  // Accessing tweets
  for (var tweet in tweetData.tweets) {
    print("Tweet: ${tweet.tweet}");
  }
} */
