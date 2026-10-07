import "dart:math";

import "package:flutter_riverpod/flutter_riverpod.dart";

import "../data/sample_feed.dart";
import "../models/feed_models.dart";
import "supabase_providers.dart";

/// The logged-in user's email, or their ID if there is no email.
final authorProvider = Provider<String>((ref) {
  ref.watch(authStateProvider); // recompute when someone signs in or out
  final user = ref.watch(supabaseProvider).auth.currentUser;
  final email = user?.email;
  if (email != null && email.isNotEmpty) return email;
  return user?.id ?? "unknown";
});

class FeedNotifier extends Notifier<List<FeedPost>> {
  @override
  List<FeedPost> build() {
    ref.watch(authorProvider); // start a fresh feed when the user changes
    return buildSamplePosts();
  }

  void _update(String id, FeedPost Function(FeedPost) change) {
    state = [
      for (final p in state)
        if (p.id == id) change(p) else p,
    ];
  }

  void toggleLike(String id) =>
      _update(id, (p) => p.copyWith(liked: !p.liked));

  void like(String id) =>
      _update(id, (p) => p.liked ? p : p.copyWith(liked: true));

  void toggleSave(String id) =>
      _update(id, (p) => p.copyWith(saved: !p.saved));

  void addComment(String id, String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    _update(
      id,
          (p) => p.copyWith(comments: [...p.comments, FeedComment(text: t)]),
    );
  }

  void hide(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  /// Creates a post by the logged-in user, with a photo from the topic.
  void addPost({
    required String caption,
    required String location,
    required FeedCategory category,
  }) {
    final pool = kPhotoPool[category]!;
    final photo = pool[Random().nextInt(pool.length)];

    final post = FeedPost(
      id: "n${DateTime.now().millisecondsSinceEpoch}",
      category: category,
      imageUrls: photo,
      caption: caption.trim().isEmpty ? "New post" : caption.trim(),
      location: location.trim().isEmpty ? "Somewhere" : location.trim(),
      timeAgo: "Just now",
      baseLikes: 0,
    );
    state = [post, ...state];
  }
}

final feedProvider =
NotifierProvider<FeedNotifier, List<FeedPost>>(FeedNotifier.new);

/// Channels the user follows (by handle).
class FollowNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String handle) {
    final next = {...state};
    if (!next.remove(handle)) next.add(handle);
    state = next;
  }
}

final followedProvider =
NotifierProvider<FollowNotifier, Set<String>>(FollowNotifier.new);

/// Stories the user already opened (their ring turns grey).
class SeenStoriesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void markSeen(String id) {
    if (!state.contains(id)) state = {...state, id};
  }
}

final seenStoriesProvider =
NotifierProvider<SeenStoriesNotifier, Set<String>>(SeenStoriesNotifier.new);