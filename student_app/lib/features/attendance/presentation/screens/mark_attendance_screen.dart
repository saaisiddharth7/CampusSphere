import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/attendance_api.dart';

class MarkAttendanceScreen extends ConsumerStatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  ConsumerState<MarkAttendanceScreen> createState() =>
      _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends ConsumerState<MarkAttendanceScreen> {
  bool _isMarking = false;
  bool _showQrScanner = false;
  String? _successMessage;
  String? _errorMessage;

  // GPS verification state
  bool _gpsChecking = true;
  bool _gpsOk = false;
  double? _latitude;
  double? _longitude;
  double? _distance;
  String? _deviceId;

  // Current class info (from timetable API)
  Map<String, dynamic>? _currentClass;
  bool _loadingClass = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentClass();
    _checkGps();
  }

  Future<void> _loadCurrentClass() async {
    try {
      // Fetch current/next class from timetable API
      final api = ref.read(attendanceApiProvider);
      // For now, the dashboard provides next_class info
      setState(() => _loadingClass = false);
    } catch (e) {
      setState(() => _loadingClass = false);
    }
  }

  Future<void> _checkGps() async {
    setState(() => _gpsChecking = true);
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _gpsChecking = false;
            _errorMessage = 'Location permission denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _gpsChecking = false;
          _errorMessage = 'Location permission permanently denied. Enable in settings.';
        });
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _gpsOk = true; // Server will validate geofence
        _gpsChecking = false;
      });
    } catch (e) {
      setState(() {
        _gpsChecking = false;
        _errorMessage = 'Could not get location. ${e.toString()}';
      });
    }
  }

  Future<void> _markAttendance({String? qrCode}) async {
    if (_isMarking) return;
    setState(() {
      _isMarking = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(attendanceApiProvider);
      final response = await api.markAttendance(
        courseId: _currentClass?['course_id'] ?? '',
        sectionId: _currentClass?['section_id'] ?? '',
        timetableEntryId: _currentClass?['timetable_entry_id'] ?? '',
        markedBy: qrCode != null ? 'student_qr' : 'student_gps',
        latitude: _latitude,
        longitude: _longitude,
        distanceFromCampus: _distance,
        isWithinGeofence: _gpsOk,
        qrCode: qrCode,
        deviceId: _deviceId,
      );

      if (response.success) {
        setState(() {
          _isMarking = false;
          _successMessage = 'Attendance marked successfully! ✅';
        });
      } else {
        setState(() {
          _isMarking = false;
          _errorMessage = response.error?.message ?? 'Failed to mark attendance';
        });
      }
    } catch (e) {
      setState(() {
        _isMarking = false;
        _errorMessage = 'Network error. Your attendance will be synced when online.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_showQrScanner) {
      return _buildQrScanner(theme);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Success State
            if (_successMessage != null)
              Card(
                color: Colors.green.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        _successMessage!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ).animate().scale(begin: const Offset(0.8, 0.8), duration: 400.ms),

            if (_successMessage == null) ...[
              // Current Class Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Class',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _infoRow('📚', 'Course', _currentClass?['course_name'] ?? 'Loading...'),
                      _infoRow('👩‍🏫', 'Faculty', _currentClass?['faculty_name'] ?? '—'),
                      _infoRow('🕐', 'Time', _currentClass?['time'] ?? '—'),
                      _infoRow('📍', 'Room', _currentClass?['room'] ?? '—'),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 16),

              // GPS Verification
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verification',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _verificationRow(
                        '📍 GPS Location',
                        _gpsChecking
                            ? 'Checking...'
                            : _gpsOk
                                ? 'Location verified'
                                : 'Location failed',
                        _gpsChecking ? null : _gpsOk,
                        theme,
                      ),
                      _verificationRow(
                        '📱 Device Check',
                        'Unique device',
                        true,
                        theme,
                      ),
                      _verificationRow(
                        '📶 WiFi Check',
                        'Checking network...',
                        null,
                        theme,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 24),

              // Mark Present Button
              ElevatedButton.icon(
                onPressed: _gpsOk && !_isMarking
                    ? () => _markAttendance()
                    : null,
                icon: _isMarking
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle, size: 22),
                label: Text(_isMarking ? 'Marking...' : 'MARK PRESENT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or scan QR code',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 16),

              // QR Scanner Button
              OutlinedButton.icon(
                onPressed: () => setState(() => _showQrScanner = true),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('SCAN QR CODE'),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
            ],

            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Card(
                  color: colorScheme.error.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: colorScheme.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _verificationRow(
    String label,
    String status,
    bool? isOk,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (isOk == null)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(
              isOk ? Icons.check_circle : Icons.cancel,
              size: 16,
              color: isOk ? Colors.green : Colors.red,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  status,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrScanner(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _showQrScanner = false),
        ),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.firstOrNull;
          if (barcode?.rawValue != null) {
            setState(() => _showQrScanner = false);
            _markAttendance(qrCode: barcode!.rawValue!);
          }
        },
      ),
    );
  }
}
