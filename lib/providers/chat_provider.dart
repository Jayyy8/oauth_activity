import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatThread {
  final String id;
  final String name;

  const ChatThread(this.id, this.name);
}

const List<ChatThread> kChatThreads = [
  ChatThread("nba", "NBA Fans"),
  ChatThread("football", "Football Talk"),
  ChatThread("news", "Daily News"),
];

class ChatMessage {
  final String text;
  final bool mine;

  const ChatMessage(this.text, {required this.mine});
}

class ChatNotifier extends Notifier<Map<String, List<ChatMessage>>> {
  @override
  Map<String, List<ChatMessage>> build() => {
    "nba": [const ChatMessage("Did you catch the game last night?", mine: false)],
    "football": [const ChatMessage("Who are you backing this weekend?", mine: false)],
    "news": [const ChatMessage("Morning headlines are out.", mine: false)],
  };

  void send(String threadId, String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    state = {
      ...state,
      threadId: [
        ...(state[threadId] ?? <ChatMessage>[]),
        ChatMessage(t, mine: true),
      ],
    };
  }
}

final chatProvider =
NotifierProvider<ChatNotifier, Map<String, List<ChatMessage>>>(
  ChatNotifier.new,
);