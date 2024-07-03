class Comment {
  final int commentId;
  final int twtId;
  final String username;
  final String displayName;
  final String comment;

  Comment({
    required this.commentId,
    required this.twtId,
    required this.username,
    required this.displayName,
    required this.comment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      twtId: json['twtId'],
      username: json['username'],
      displayName: json['displayName'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'twtId': twtId,
      'username': username,
      'displayName': displayName,
      'comment': comment
    };
  }
}
