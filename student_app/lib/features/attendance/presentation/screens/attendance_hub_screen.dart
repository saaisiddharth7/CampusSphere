import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../data/attendance_api.dart';

class AttendanceHubScreen extends ConsumerStatefulWidget {
  const AttendanceHubScreen({super.key});

  @override
  ConsumerState<AttendanceHubScreen> createState() =>
      _AttendanceHubScreenState();
}

class _AttendanceHubScreenState extends ConsumerState<AttendanceHubScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _stats;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final api = ref.read(attendanceApiProvider);
      final response = await api.getStats();
      if (response.success && response.data != null) {
        setState(() {
          _stats = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.error?.message ?? 'Failed to load stats';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error. Pull to refresh.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to full history
            },
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _stats == null
                ? _buildError()
                : _buildContent(theme, colorScheme),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    final overallPercentage =
        (_stats?['overall_percentage'] ?? 0.0).toDouble() / 100.0;
    final subjects = _stats?['subjects'] as List? ?? [];
    final minimum = (_stats?['attendance_minimum'] ?? 75.0).toDouble();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Overall Attendance Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Overall Attendance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CircularPercentIndicator(
                    radius: 60,
                    lineWidth: 10,
                    percent: overallPercentage.clamp(0.0, 1.0),
                    center: Text(
                      '${(overallPercentage * 100).toStringAsFixed(1)}%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    progressColor: overallPercentage * 100 >= minimum
                        ? Colors.green
                        : Colors.red,
                    backgroundColor: colorScheme.surfaceContainerHigh,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1000,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    overallPercentage * 100 >= minimum
                        ? '✅ ${((overallPercentage * 100) - minimum).toStringAsFixed(1)}% above minimum'
                        : '⚠️ ${(minimum - (overallPercentage * 100)).toStringAsFixed(1)}% below minimum',
                    style: TextStyle(
                      color: overallPercentage * 100 >= minimum
                          ? Colors.green
                          : colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 16),

          // Mark Attendance Button
          ElevatedButton.icon(
            onPressed: () => context.push('/attendance/mark'),
            icon: const Icon(Icons.location_on, size: 22),
            label: const Text('MARK ATTENDANCE'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).scale(
                begin: const Offset(0.95, 0.95),
                duration: 400.ms,
              ),

          const SizedBox(height: 24),

          // Subject-wise Breakdown
          Text(
            'Subject-wise',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          ...subjects.asMap().entries.map((entry) {
            final index = entry.key;
            final subject = entry.value as Map<String, dynamic>;
            final percentage =
                (subject['percentage'] ?? 0.0).toDouble();

            return Card(
              child: ListTile(
                title: Text(
                  '${subject['course_code'] ?? ''} ${subject['course_name'] ?? ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: LinearPercentIndicator(
                    lineHeight: 8,
                    percent: (percentage / 100).clamp(0.0, 1.0),
                    backgroundColor: colorScheme.surfaceContainerHigh,
                    progressColor: percentage >= minimum
                        ? Colors.green
                        : percentage >= minimum - 5
                            ? Colors.orange
                            : Colors.red,
                    barRadius: const Radius.circular(4),
                    padding: EdgeInsets.zero,
                    animation: true,
                    animationDuration: 800,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: percentage >= minimum
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    Text(
                      percentage >= minimum ? '✅' : '🔴',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to subject attendance detail
                },
              ),
            ).animate().fadeIn(
                  delay: Duration(milliseconds: 200 + index * 100),
                  duration: 400.ms,
                );
          }),

          const SizedBox(height: 24),

          // View Full History
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to full history page
            },
            icon: const Icon(Icons.history),
            label: const Text('View Full History'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(_error ?? 'Unknown error'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadStats, child: const Text('Retry')),
        ],
      ),
    );
  }
}
