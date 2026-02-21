import 'dart:async';
import 'package:flutter/material.dart';

/// Watch recording screen — plays back a recorded meeting.
class WatchRecordingScreen extends StatefulWidget {
  final String meetingId;
  final String title;
  final String section;
  final String date;
  final String duration;
  final int participants;

  const WatchRecordingScreen({
    super.key,
    required this.meetingId,
    required this.title,
    required this.section,
    required this.date,
    required this.duration,
    required this.participants,
  });

  @override
  State<WatchRecordingScreen> createState() => _WatchRecordingScreenState();
}

class _WatchRecordingScreenState extends State<WatchRecordingScreen> {
  bool _isPlaying = false;
  double _progress = 0.0;
  double _volume = 0.8;
  double _playbackSpeed = 1.0;
  int _currentSeconds = 0;
  int _totalSeconds = 0;
  Timer? _playTimer;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    // Parse duration string to seconds
    final parts = widget.duration.split(' ');
    final mins = int.tryParse(parts[0]) ?? 42;
    _totalSeconds = mins * 60;
  }

  @override
  void dispose() {
    _playTimer?.cancel();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);

    if (_isPlaying) {
      _playTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (!mounted) return;
        setState(() {
          _currentSeconds += (_playbackSpeed * 0.1).round();
          _progress = _currentSeconds / _totalSeconds;
          if (_progress >= 1.0) {
            _progress = 1.0;
            _isPlaying = false;
            _playTimer?.cancel();
          }
        });
      });
    } else {
      _playTimer?.cancel();
    }
  }

  void _seekTo(double value) {
    setState(() {
      _progress = value;
      _currentSeconds = (value * _totalSeconds).round();
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _toggleControlsVisibility() {
    setState(() => _showControls = true);
    _hideControlsTimer?.cancel();
    if (_isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControlsVisibility,
        child: Stack(
          children: [
            // Video area (simulated)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Simulated video content
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1a1a2e),
                          const Color(0xFF16213e),
                          colorScheme.primary.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Slide content simulation
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.slideshow_rounded,
                              size: 48,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Recorded Session',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        // Faculty PiP overlay
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366f1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24, width: 2),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('LP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Host', style: TextStyle(color: Colors.white60, fontSize: 9)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Controls overlay
            if (_showControls) ...[
              // Top bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 8,
                    right: 16,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () {
                          _playTimer?.cancel();
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${widget.section} • ${widget.date} • ${widget.participants} attendees',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    left: 16,
                    right: 16,
                    top: 24,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress bar
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          activeTrackColor: colorScheme.primary,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: colorScheme.primary,
                          overlayColor: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: _progress.clamp(0.0, 1.0),
                          onChanged: _seekTo,
                          onChangeStart: (_) {
                            _playTimer?.cancel();
                          },
                          onChangeEnd: (value) {
                            if (_isPlaying) {
                              _togglePlay(); // restart
                              _togglePlay();
                            }
                          },
                        ),
                      ),

                      // Time and controls
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              _formatTime(_currentSeconds),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              ' / ${_formatTime(_totalSeconds)}',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                            ),
                            const Spacer(),

                            // Rewind
                            IconButton(
                              icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 28),
                              onPressed: () {
                                _seekTo(((_currentSeconds - 10) / _totalSeconds).clamp(0.0, 1.0));
                              },
                            ),

                            // Play/Pause
                            GestureDetector(
                              onTap: _togglePlay,
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),

                            // Forward
                            IconButton(
                              icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 28),
                              onPressed: () {
                                _seekTo(((_currentSeconds + 10) / _totalSeconds).clamp(0.0, 1.0));
                              },
                            ),

                            const Spacer(),

                            // Speed
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_playbackSpeed == 1.0) {
                                    _playbackSpeed = 1.5;
                                  } else if (_playbackSpeed == 1.5) {
                                    _playbackSpeed = 2.0;
                                  } else {
                                    _playbackSpeed = 1.0;
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white38),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${_playbackSpeed}x',
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Play button overlay when paused and controls hidden
            if (!_showControls && !_isPlaying)
              Center(
                child: GestureDetector(
                  onTap: () {
                    _toggleControlsVisibility();
                    _togglePlay();
                  },
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
