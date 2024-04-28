class Tweet {
  int id;
  String username;
  String displayName;
  String tweet;
  String image;
  String timestamp;
  int likes;
  int retweets;
  int commentCount;

  Tweet({
    required this.id,
    required this.username,
    required this.displayName,
    required this.tweet,
    required this.image,
    required this.timestamp,
    required this.likes,
    required this.retweets,
    this.commentCount = 0,
  });
}

class TweetData {
  List<Tweet> tweets = [
    Tweet(
      id: 1,
      username: "@JohnDoe",
      displayName: "johndoe",
      tweet: "Just had a fantastic day exploring the city! #travel",
      image: "assets/images/image1.jpg",
      timestamp: "2024-04-25T08:00:00Z",
      likes: 100,
      retweets: 50,
    ),
    Tweet(
      id: 2,
      username: "@JaneSmith",
      displayName: "janesmith",
      tweet: "Excited to announce my new blog post! Check it out: [link]",
      image: "none",
      timestamp: "2024-04-24T10:30:00Z",
      likes: 200,
      retweets: 75,
    ),
    Tweet(
      id: 3,
      username: "@TechGeek",
      displayName: "techgeek",
      tweet: "Just received the latest tech gadget! Can't wait to try it out.",
      image: "none",
      timestamp: "2024-04-23T15:45:00Z",
      likes: 150,
      retweets: 30,
    ),
    Tweet(
      id: 4,
      username: "@Foodie",
      displayName: "@foodie",
      tweet: "Enjoying a delicious meal at my favorite restaurant! #foodlover",
      image: "none",
      timestamp: "2024-04-22T12:15:00Z",
      likes: 300,
      retweets: 100,
    ),
    Tweet(
      id: 5,
      username: "@SportsFan",
      displayName: "sportsfan",
      tweet: "What a game last night! Can't believe the comeback victory!",
      image: "none",
      timestamp: "2024-04-21T20:00:00Z",
      likes: 250,
      retweets: 80,
    ),
        Tweet(
      id: 6,
      username: "@test",
      displayName: "sbambino",
      tweet: "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
      image: "none",
      timestamp: "2024-04-21T20:00:00Z",
      likes: 250,
      retweets: 80,
    ),
            Tweet(
      id: 6,
      username: "@test",
      displayName: "sbambino",
      tweet: "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
      image: "none",
      timestamp: "2024-04-21T20:00:00Z",
      likes: 250,
      retweets: 80,
    ),
            Tweet(
      id: 6,
      username: "@test",
      displayName: "sbambino",
      tweet: "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
      image: "none",
      timestamp: "2024-04-21T20:00:00Z",
      likes: 250,
      retweets: 80,
    ),
            Tweet(
      id: 6,
      username: "@test",
      displayName: "sbambino",
      tweet: "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
      image: "none",
      timestamp: "2024-04-21T20:00:00Z",
      likes: 250,
      retweets: 80,
    ),
            Tweet(
      id: 6,
      username: "@test",
      displayName: "sbambino",
      tweet: "#sly #weiner shit my self your not harder point i say or i say whats hard as swing controll",
      image: "none",
      timestamp: "2024-04-21T20:00:00Z",
      likes: 250,
      retweets: 80,
    ),
  ];

  void addTweet(Tweet tweet) {
    tweets.insert(0, tweet); // supaya saat tweet baru ditambah, akan diletakkan di paling atas
  }

  void deleteTweet(int index) {
    if (index >= 0 && index < tweets.length) {
      tweets.removeAt(index);
    }
  }

  void updateTweet(int index, Tweet tweet) {
    if (index >= 0 && index < tweets.length) {
      tweets[index] = tweet;
    }
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
