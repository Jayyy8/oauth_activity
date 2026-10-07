import "../models/feed_models.dart";

const List<StoryTopic> kStoryTopics = [
  StoryTopic(
    id: "nba",
    label: "NBA",
    category: FeedCategory.nba,
    seeds: [21, 22, 23],
  ),
  StoryTopic(
    id: "football",
    label: "Football",
    category: FeedCategory.football,
    seeds: [31, 32, 33],
  ),
  StoryTopic(
    id: "news",
    label: "News",
    category: FeedCategory.news,
    seeds: [41, 42, 43],
  ),
  StoryTopic(
    id: "tennis",
    label: "Tennis",
    category: FeedCategory.tennis,
    seeds: [51, 52, 53],
  ),
];

List<FeedPost> buildSamplePosts() => [
  FeedPost(
    id: "p1",
    category: FeedCategory.nba,
    imageUrl: photoUrl(FeedCategory.nba, 101),
    caption: "Game night energy. Loud crowd, fast pace.",
    location: "Basketball Arena",
    timeAgo: "2 hours ago",
    baseLikes: 128,
    comments: const [
      FeedComment(author: "alex.hoops", text: "That atmosphere is unreal."),
      FeedComment(author: "court_vision", text: "Best seats in the house."),
    ],
  ),
  FeedPost(
    id: "p2",
    category: FeedCategory.football,
    imageUrl: photoUrl(FeedCategory.football, 102),
    caption: "Match day. The stadium is already full.",
    location: "City Stadium",
    timeAgo: "4 hours ago",
    baseLikes: 342,
    comments: const [
      FeedComment(author: "sofia_fc", text: "Can't wait for kickoff!"),
    ],
  ),
  FeedPost(
    id: "p3",
    category: FeedCategory.news,
    imageUrl: photoUrl(FeedCategory.news, 103),
    caption: "Front page stories this morning.",
    location: "Newsroom",
    timeAgo: "6 hours ago",
    baseLikes: 87,
  ),
  FeedPost(
    id: "p4",
    category: FeedCategory.tennis,
    imageUrl: photoUrl(FeedCategory.tennis, 104),
    caption: "Center court, early rally.",
    location: "Grand Court",
    timeAgo: "Yesterday",
    baseLikes: 215,
    comments: const [
      FeedComment(author: "baseline_ben", text: "What a rally."),
    ],
  ),
  FeedPost(
    id: "p5",
    category: FeedCategory.nba,
    imageUrl: photoUrl(FeedCategory.nba, 105),
    caption: "Practice makes permanent.",
    location: "Training Gym",
    timeAgo: "Yesterday",
    baseLikes: 64,
  ),
  FeedPost(
    id: "p6",
    category: FeedCategory.football,
    imageUrl: photoUrl(FeedCategory.football, 106),
    caption: "Pitch looking perfect before the game.",
    location: "Training Ground",
    timeAgo: "2 days ago",
    baseLikes: 178,
  ),
  FeedPost(
    id: "p7",
    category: FeedCategory.news,
    imageUrl: photoUrl(FeedCategory.news, 107),
    caption: "Reading the headlines with coffee.",
    location: "Downtown",
    timeAgo: "2 days ago",
    baseLikes: 52,
  ),
  FeedPost(
    id: "p8",
    category: FeedCategory.tennis,
    imageUrl: photoUrl(FeedCategory.tennis, 108),
    caption: "Serving practice at sunrise.",
    location: "Tennis Club",
    timeAgo: "3 days ago",
    baseLikes: 96,
  ),
];