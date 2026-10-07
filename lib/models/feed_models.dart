enum FeedCategory { nba, football, news, tennis }

extension FeedCategoryX on FeedCategory {
  String get label {
    switch (this) {
      case FeedCategory.nba:
        return "NBA";
      case FeedCategory.football:
        return "Football";
      case FeedCategory.news:
        return "News";
      case FeedCategory.tennis:
        return "Tennis";
    }
  }

  /// Keyword used to pick a matching photo.
  String get keyword {
    switch (this) {
      case FeedCategory.nba:
        return "basketball";
      case FeedCategory.football:
        return "soccer";
      case FeedCategory.news:
        return "newspaper";
      case FeedCategory.tennis:
        return "tennis";
    }
  }
}

/// Real photo matched to a topic. The same [seed] always gives the same photo.
/// To use your own images, just return your own URL here.
String photoUrl(
    FeedCategory category,
    int seed, {
      int width = 1000,
      int height = 1250,
    }) =>
    "https://loremflickr.com/$width/$height/${category.keyword}?lock=$seed";

/// "name@email.com" -> "name", long IDs -> first 8 characters.
String shortName(String full) {
  if (full.contains("@")) return full.split("@").first;
  return full.length > 8 ? full.substring(0, 8) : full;
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
  final String imageUrl;
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
    required this.imageUrl,
    required this.caption,
    required this.location,
    required this.timeAgo,
    required this.baseLikes,
    this.liked = false,
    this.saved = false,
    this.comments = const [],
  });

  int get likes => baseLikes + (liked ? 1 : 0);

  FeedPost copyWith({
    bool? liked,
    bool? saved,
    List<FeedComment>? comments,
  }) {
    return FeedPost(
      id: id,
      category: category,
      imageUrl: imageUrl,
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
  final List<int> seeds;

  const StoryTopic({
    required this.id,
    required this.label,
    required this.category,
    required this.seeds,
  });

  String get coverUrl =>
      photoUrl(category, seeds.first, width: 300, height: 300);

  List<String> get photos => [
    for (final s in seeds)
      photoUrl(category, s, width: 1080, height: 1920),
  ];
}