import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Individual chatroom with messages — faculty has moderator powers.
class ChatroomScreen extends ConsumerStatefulWidget {
  final String chatroomId;
  const ChatroomScreen({super.key, required this.chatroomId});

  @override
  ConsumerState<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends ConsumerState<ChatroomScreen> {
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final _messages = <Map<String, dynamic>>[
    {'sender': 'Rahul Kumar', 'text': 'Professor, can you explain 3NF once more?', 'time': '10:30 AM', 'isMe': false},
    {'sender': 'You', 'text': 'Sure! 3NF requires that every non-prime attribute is non-transitively dependent on every key.', 'time': '10:32 AM', 'isMe': true, 'pinned': true},
    {'sender': 'Priya Menon', 'text': 'Thank you! That clears it up 🙏', 'time': '10:33 AM', 'isMe': false},
    {'sender': 'Arun K', 'text': 'What about BCNF?', 'time': '10:35 AM', 'isMe': false},
    {'sender': 'You', 'text': 'BCNF is stricter — for every FD X→Y, X must be a superkey. I\'ll cover this in tomorrow\'s class.', 'time': '10:36 AM', 'isMe': true},
    {'sender': 'Ganesh K', 'text': 'Will this be in the exam?', 'time': '10:40 AM', 'isMe': false},
    {'sender': 'You', 'text': '📌 Yes, normalization up to BCNF is important for the mid-term.', 'time': '10:41 AM', 'isMe': true, 'pinned': true},
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageCtrl.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'You',
        'text': _messageCtrl.text.trim(),
        'time': 'Now',
        'isMe': true,
      });
    });
    _messageCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DBMS — CSE-3A'),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin_outlined),
            onPressed: () {},
            tooltip: 'Pinned Messages',
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(child: Text('📢 Post Announcement')),
              const PopupMenuItem(child: Text('📌 Pinned Messages')),
              const PopupMenuItem(child: Text('👥 Members (53)')),
              const PopupMenuItem(child: Text('🔇 Mute Chat')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                final isMe = msg['isMe'] as bool;
                final isPinned = msg['pinned'] == true;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isMe ? const Radius.circular(4) : null,
                        bottomLeft: !isMe ? const Radius.circular(4) : null,
                      ),
                      border: isPinned
                          ? Border.all(color: colorScheme.tertiary, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              msg['sender'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        if (isPinned)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.push_pin_rounded, size: 12, color: colorScheme.tertiary),
                                const SizedBox(width: 4),
                                Text('Pinned', style: TextStyle(fontSize: 10, color: colorScheme.tertiary)),
                              ],
                            ),
                          ),
                        Text(msg['text'] as String),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'] as String,
                          style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageCtrl,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
