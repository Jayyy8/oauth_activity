enum FeedCategory { nba, football, news, docs }

extension FeedCategoryX on FeedCategory {
  String get label {
    switch (this) {
      case FeedCategory.nba:
        return "NBA";
      case FeedCategory.football:
        return "Football";
      case FeedCategory.news:
        return "News";
      case FeedCategory.docs:
        return "Docs";
    }
  }
}

/// 12840 -> "12,840"
String formatCount(int n) {
  final s = n.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write(",");
    buffer.write(s[i]);
  }
  return buffer.toString();
}

/// "name@email.com" -> "name", long IDs -> first 8 characters.
String shortName(String full) {
  if (full.contains("@")) return full.split("@").first;
  return full.length > 8 ? full.substring(0, 8) : full;
}

/// A news / sports / documentary account that "posts" in the feed.
class FeedChannel {
  final String handle;
  final bool verified;

  const FeedChannel(this.handle, {this.verified = true});
}

class FeedComment {
  /// null = written by the logged-in user.
  final String? author;
  final String text;

  const FeedComment({this.author, required this.text});
}

class FeedPost {
  final String id;
  final FeedCategory category;

  /// null = a post created by the logged-in user.
  final FeedChannel? channel;

  /// Tried in order: if the first photo fails to load, the next one is used.
  final List<String> imageUrls;
  final String caption;
  final String location;
  final String timeAgo;
  final int baseLikes;
  final bool liked;
  final bool saved;
  final List<FeedComment> comments;

  const FeedPost({
    required this.id,
    required this.category,
    required this.imageUrls,
    required this.caption,
    required this.location,
    required this.timeAgo,
    required this.baseLikes,
    this.channel,
    this.liked = false,
    this.saved = false,
    this.comments = const [],
  });

  bool get mine => channel == null;
  String get authorName => channel?.handle ?? "you";
  int get likes => baseLikes + (liked ? 1 : 0);

  FeedPost copyWith({
    bool? liked,
    bool? saved,
    List<FeedComment>? comments,
  }) {
    return FeedPost(
      id: id,
      category: category,
      channel: channel,
      imageUrls: imageUrls,
      caption: caption,
      location: location,
      timeAgo: timeAgo,
      baseLikes: baseLikes,
      liked: liked ?? this.liked,
      saved: saved ?? this.saved,
      comments: comments ?? this.comments,
    );
  }
}

class StoryTopic {
  final String id;
  final String label;
  final FeedCategory category;
  final FeedChannel channel;

  /// One entry per story photo; each entry is a list of fallback URLs.
  final List<List<String>> photos;

  StoryTopic({
    required this.id,
    required this.label,
    required this.category,
    required this.channel,
    required this.photos,
  });
}