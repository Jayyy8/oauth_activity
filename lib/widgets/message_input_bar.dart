import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

/// Text field + send button used for comments and chat.
class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final VoidCallback onSend;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        12 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: GlassTextField(
              controller: controller,
              placeholder: placeholder,
            ),
          ),
          const SizedBox(width: 8),
          GlassButton(
            icon: const Icon(CupertinoIcons.paperplane_fill),
            label: "Send",
            width: 48,
            height: 48,
            iconSize: 20,
            useOwnLayer: true,
            settings: LiquidGlassSettings(
              glassColor: const Color(0xB32B3BFF),
              blur: 8,
            ),
            onTap: onSend,
          ),
        ],
      ),
    );
  }
}