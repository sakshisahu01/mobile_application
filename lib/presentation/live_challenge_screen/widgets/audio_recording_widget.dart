import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

/// Simple audio recorder UI (simulated without native recording library)
/// - Requests microphone permission
/// - Simulates recording via a timer, returns a fake file path on stop
class AudioRecordingWidget extends StatefulWidget {
  final Function(String) onAudioRecorded;

  const AudioRecordingWidget({Key? key, required this.onAudioRecorded}) : super(key: key);

  @override
  State<AudioRecordingWidget> createState() => _AudioRecordingWidgetState();
}

class _AudioRecordingWidgetState extends State<AudioRecordingWidget> {
  bool _hasPermission = false;
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    if (kIsWeb) {
      setState(() => _hasPermission = true);
      return;
    }

    final status = await Permission.microphone.request();
    setState(() {
      _hasPermission = status.isGranted;
      if (!_hasPermission) _error = 'Microphone permission is required to record audio.';
    });
  }

  void _startRecording() {
    if (!_hasPermission) return;
    setState(() {
      _isRecording = true;
      _seconds = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _seconds++);
      if (_seconds >= 60) _stopRecording(); // cap at 60s
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    setState(() => _isRecording = false);
    // Return a fake file path to the caller
    final fakePath = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
    widget.onAudioRecorded(fakePath);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_error != null) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Microphone unavailable', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 1.h),
            Text(_error!, textAlign: TextAlign.center),
            SizedBox(height: 2.h),
            ElevatedButton(onPressed: _checkPermission, child: Text('Retry'))
          ],
        ),
      );
    }

    if (!_hasPermission) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Microphone permission required', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 1.h),
            Text('Please grant microphone permission to record audio answers.'),
            SizedBox(height: 2.h),
            ElevatedButton(onPressed: _checkPermission, child: Text('Grant Permission'))
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isRecording ? 'Recording...' : 'Record an audio answer',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          if (_isRecording)
            Text('${_seconds}s', style: theme.textTheme.displaySmall?.copyWith(fontSize: 18.sp)),
          SizedBox(height: 2.h),
          Center(
            child: _isRecording
                ? ElevatedButton.icon(
                    onPressed: _stopRecording,
                    icon: Icon(Icons.stop),
                    label: Text('Stop'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  )
                : ElevatedButton.icon(
                    onPressed: _startRecording,
                    icon: Icon(Icons.mic),
                    label: Text('Start Recording'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D2DFF)),
                  ),
          ),
        ],
      ),
    );
  }
}
