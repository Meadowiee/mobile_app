import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String username;
  final String message;
  final String? time;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.username,
    required this.message,
    required this.time,
  });

  String _formatTime(String? iso) {
    if (iso == null) return "";
    final dt = DateTime.tryParse(iso);
    if (dt == null) return "";
    final local = dt.toLocal();
    return "${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final timeText = _formatTime(time);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(
                fontFamily: "Georgia",
                fontSize: 12,
                color: isMe ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: TextStyle(
                fontFamily: "Georgia",
                fontSize: 14,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            if (timeText.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                timeText,
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white60 : Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
