import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../providers/chat_provider.dart";
import "../widgets/auth_button.dart";
import "../widgets/message_input_bar.dart";
import "../widgets/sub_page.dart";

class ChatPage extends ConsumerStatefulWidget {
  final ChatThread thread;

  const ChatPage({super.key, required this.thread});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    ref.read(chatProvider.notifier).send(widget.thread.id, _controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider)[widget.thread.id] ?? [];
    final bool isDark =
        CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final Color theirs =
    isDark ? const Color(0xFF2A2A2E) : const Color(0xFFE9E9EE);

    return SubPage(
      title: widget.thread.name,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                return Align(
                  alignment:
                  m.mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: m.mine ? kAuthBlue : theirs,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: m.mine ? CupertinoColors.white : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          MessageInputBar(
            controller: _controller,
            placeholder: "Message...",
            onSend: _send,
          ),
        ],
      ),
    );
  }
}