import "package:flutter/cupertino.dart";

/// One post in the feed. The author is not stored here: the home page
/// fills it in with the logged-in user's email or ID.
class FeedPost {
  final String caption;
  final String location;
  final int likes;
  final int comments;
  final String timeAgo;
  final List<Color> colors;
  final IconData icon;

  const FeedPost({
    required this.caption,
    required this.location,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    required this.colors,
    required this.icon,
  });
}

/// Sample content. Replace with real data later (for example a Supabase table).
const List<FeedPost> kSamplePosts = [
  FeedPost(
    caption: "Golden hour never gets old.",
    location: "Sunset Beach",
    likes: 128,
    comments: 14,
    timeAgo: "2 hours ago",
    colors: [Color(0xFFFFB000), Color(0xFFFF2D55)],
    icon: CupertinoIcons.sun_max,
  ),
  FeedPost(
    caption: "Late night thoughts and a good playlist.",
    location: "Home",
    likes: 342,
    comments: 29,
    timeAgo: "5 hours ago",
    colors: [Color(0xFF8E2DE2), Color(0xFF2B3BFF)],
    icon: CupertinoIcons.moon_stars,
  ),
  FeedPost(
    caption: "Fresh coffee, fresh start.",
    location: "Downtown Cafe",
    likes: 87,
    comments: 6,
    timeAgo: "Yesterday",
    colors: [Color(0xFFFF7A18), Color(0xFFAF002D)],
    icon: CupertinoIcons.flame,
  ),
  FeedPost(
    caption: "Found a new trail. Totally worth the climb.",
    location: "Mountain Trail",
    likes: 215,
    comments: 18,
    timeAgo: "2 days ago",
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    icon: CupertinoIcons.map,
  ),
];