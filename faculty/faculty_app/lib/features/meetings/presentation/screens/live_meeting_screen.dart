import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Live meeting screen — faculty starts/hosts a live meeting.
/// Simulates a real video call interface with timer, participant grid,
/// chat panel, and control bar.
class LiveMeetingScreen extends ConsumerStatefulWidget {
  final String meetingId;
  final String title;
  final String section;

  const LiveMeetingScreen({
    super.key,
    required this.meetingId,
    required this.title,
    required this.section,
  });

  @override
  ConsumerState<LiveMeetingScreen> createState() => _LiveMeetingScreenState();
}

class _LiveMeetingScreenState extends ConsumerState<LiveMeetingScreen> {
  bool _micOn = true;
  bool _camOn = true;
  bool _screenSharing = false;
  bool _chatOpen = false;
  bool _handRaised = false;
  int _elapsedSeconds = 0;
  int _participantCount = 1;
  Timer? _timer;
  final _chatController = TextEditingController();

  // Demo participants that "join" over time
  final _allParticipants = [
    {'name': 'You (Host)', 'initials': 'LP', 'isHost': true, 'camOn': true},
    {'name': 'Rahul Kumar', 'initials': 'RK', 'isHost': false, 'camOn': true},
    {'name': 'Priya Menon', 'initials': 'PM', 'isHost': false, 'camOn': false},
    {'name': 'Arun Krishnan', 'initials': 'AK', 'isHost': false, 'camOn': true},
    {'name': 'Deepika R', 'initials': 'DR', 'isHost': false, 'camOn': true},
    {'name': 'Suresh V', 'initials': 'SV', 'isHost': false, 'camOn': false},
    {'name': 'Anita S', 'initials': 'AS', 'isHost': false, 'camOn': true},
    {'name': 'Ganesh K', 'initials': 'GK', 'isHost': false, 'camOn': false},
  ];

  final List<Map<String, String>> _chatMessages = [];

  @override
  void initState() {
    super.initState();
    // Timer for elapsed time
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSeconds++);

      // Simulate students joining over time
      if (_elapsedSeconds == 3 && _participantCount < _allParticipants.length) {
        _addParticipant('Rahul Kumar');
      }
      if (_elapsedSeconds == 5 && _participantCount < _allParticipants.length) {
        _addParticipant('Priya Menon');
      }
      if (_elapsedSeconds == 7 && _participantCount < _allParticipants.length) {
        _addParticipant('Arun Krishnan');
      }
      if (_elapsedSeconds == 9 && _participantCount < _allParticipants.length) {
        _addParticipant('Deepika R');
      }
      if (_elapsedSeconds == 12 && _participantCount < _allParticipants.length) {
        _addParticipant('Suresh V');
        _addParticipant('Anita S');
      }
      if (_elapsedSeconds == 15 && _participantCount < _allParticipants.length) {
        _addParticipant('Ganesh K');
      }

      // Simulate chat messages
      if (_elapsedSeconds == 6) {
        _addChatMessage('Rahul Kumar', 'Good afternoon, Professor!');
      }
      if (_elapsedSeconds == 10) {
        _addChatMessage('Priya Menon', 'Audio is clear 👍');
      }
      if (_elapsedSeconds == 16) {
        _addChatMessage('Arun Krishnan', 'Can you share the slides?');
      }
    });
  }

  void _addParticipant(String name) {
    setState(() {
      _participantCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name joined'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      ),
    );
  }

  void _addChatMessage(String sender, String msg) {
    setState(() {
      _chatMessages.add({'sender': sender, 'text': msg});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chatController.dispose();
    super.dispose();
  }

  String get _elapsed {
    final m = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _endMeeting() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End Meeting?'),
        content: Text(
          'Duration: $_elapsed\n'
          'Participants: $_participantCount\n\n'
          'The recording will be saved and available for students to watch.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true); // Return to meeting list
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('End Meeting'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final participants = _allParticipants.take(_participantCount).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Meeting info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.section,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // Timer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'LIVE $_elapsed',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Participant count
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_rounded, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$_participantCount',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Video grid
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: participants.length <= 2 ? 1 : 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: participants.length <= 2 ? 16 / 9 : 4 / 3,
                      ),
                      itemCount: participants.length,
                      itemBuilder: (context, idx) {
                        final p = participants[idx];
                        final isHost = p['isHost'] == true;
                        final camOn = isHost ? _camOn : (p['camOn'] == true);

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF16213e),
                            borderRadius: BorderRadius.circular(16),
                            border: isHost
                                ? Border.all(color: colorScheme.primary, width: 2)
                                : null,
                          ),
                          child: Stack(
                            children: [
                              // Video / Avatar
                              Center(
                                child: camOn
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: participants.length <= 2 ? 40 : 28,
                                            backgroundColor: _avatarColor(idx),
                                            child: Text(
                                              p['initials'] as String,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: participants.length <= 2 ? 20 : 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              '📹 Camera On',
                                              style: TextStyle(color: Colors.green, fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: participants.length <= 2 ? 40 : 28,
                                            backgroundColor: Colors.grey[700],
                                            child: Text(
                                              p['initials'] as String,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                                fontSize: participants.length <= 2 ? 20 : 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Camera Off',
                                            style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10),
                                          ),
                                        ],
                                      ),
                              ),

                              // Name tag
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isHost) ...[
                                        const Icon(Icons.shield_rounded, color: Colors.amber, size: 12),
                                        const SizedBox(width: 4),
                                      ],
                                      Text(
                                        p['name'] as String,
                                        style: const TextStyle(color: Colors.white, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Screen share indicator
                              if (isHost && _screenSharing)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.screen_share_rounded, color: Colors.white, size: 12),
                                        SizedBox(width: 4),
                                        Text('Sharing', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Chat panel
                  if (_chatOpen)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      top: 8,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0f3460),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            // Chat header
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  const Text('Meeting Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => setState(() => _chatOpen = false),
                                    child: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.white12),
                            // Messages
                            Expanded(
                              child: _chatMessages.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No messages yet',
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(12),
                                      itemCount: _chatMessages.length,
                                      itemBuilder: (context, idx) {
                                        final msg = _chatMessages[idx];
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                msg['sender']!,
                                                style: TextStyle(color: colorScheme.primary, fontSize: 11, fontWeight: FontWeight.w600),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(msg['text']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            // Chat input
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                border: Border(top: BorderSide(color: Colors.white12)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _chatController,
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                      decoration: InputDecoration(
                                        hintText: 'Type a message...',
                                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                      onSubmitted: (text) {
                                        if (text.trim().isNotEmpty) {
                                          _addChatMessage('You', text.trim());
                                          _chatController.clear();
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send_rounded, color: Colors.white70, size: 20),
                                    onPressed: () {
                                      if (_chatController.text.trim().isNotEmpty) {
                                        _addChatMessage('You', _chatController.text.trim());
                                        _chatController.clear();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Control bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF16213e),
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ControlButton(
                    icon: _micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                    label: _micOn ? 'Mute' : 'Unmute',
                    isActive: _micOn,
                    onTap: () => setState(() => _micOn = !_micOn),
                  ),
                  _ControlButton(
                    icon: _camOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                    label: _camOn ? 'Camera' : 'Camera Off',
                    isActive: _camOn,
                    onTap: () => setState(() => _camOn = !_camOn),
                  ),
                  _ControlButton(
                    icon: _screenSharing ? Icons.stop_screen_share_rounded : Icons.screen_share_rounded,
                    label: _screenSharing ? 'Stop Share' : 'Share',
                    isActive: !_screenSharing,
                    activeColor: _screenSharing ? Colors.green : null,
                    onTap: () => setState(() => _screenSharing = !_screenSharing),
                  ),
                  _ControlButton(
                    icon: Icons.chat_rounded,
                    label: 'Chat',
                    isActive: true,
                    badge: _chatMessages.isNotEmpty && !_chatOpen ? '${_chatMessages.length}' : null,
                    onTap: () => setState(() => _chatOpen = !_chatOpen),
                  ),
                  _ControlButton(
                    icon: _handRaised ? Icons.pan_tool_rounded : Icons.pan_tool_alt_rounded,
                    label: _handRaised ? 'Lower' : 'Raise',
                    isActive: !_handRaised,
                    activeColor: _handRaised ? Colors.amber : null,
                    onTap: () => setState(() => _handRaised = !_handRaised),
                  ),
                  _ControlButton(
                    icon: Icons.call_end_rounded,
                    label: 'End',
                    isActive: false,
                    isEnd: true,
                    onTap: _endMeeting,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _avatarColor(int idx) {
    const colors = [
      Color(0xFF6366f1),
      Color(0xFFec4899),
      Color(0xFF14b8a6),
      Color(0xFFf97316),
      Color(0xFF8b5cf6),
      Color(0xFF06b6d4),
      Color(0xFFef4444),
      Color(0xFF84cc16),
    ];
    return colors[idx % colors.length];
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isEnd;
  final Color? activeColor;
  final String? badge;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.isActive = true,
    this.isEnd = false,
    this.activeColor,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isEnd
                      ? Colors.red
                      : activeColor ?? (isActive ? Colors.white.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.2)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isEnd
                      ? Colors.white
                      : activeColor != null
                          ? Colors.white
                          : (isActive ? Colors.white : Colors.red),
                  size: 22,
                ),
              ),
              if (badge != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
