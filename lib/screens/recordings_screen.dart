import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/accessibility_service.dart';
import '../services/recording_service.dart';

class RecordingsScreen extends StatefulWidget {
  const RecordingsScreen({super.key});

  @override
  State<RecordingsScreen> createState() => _RecordingsScreenState();
}

class _RecordingsScreenState extends State<RecordingsScreen> {
  final RecordingService _recordingService = RecordingService();
  List<FileSystemEntity> _recordings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accessibility = context.read<AccessibilityService>();
      accessibility.announceNavigation('Recordings');
      _loadRecordings();
    });
  }

  Future<void> _loadRecordings() async {
    setState(() {
      _isLoading = true;
    });

    final recordings = await _recordingService.getRecordings();
    
    setState(() {
      _recordings = recordings;
      _isLoading = false;
    });

    final accessibility = context.read<AccessibilityService>();
    await accessibility.speak('${recordings.length} recordings found');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recordings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.mic_none, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No recordings yet',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Start recording from the player screen',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _recordings.length,
                  itemBuilder: (context, index) {
                    final recording = _recordings[index];
                    return _buildRecordingTile(recording);
                  },
                ),
    );
  }

  Widget _buildRecordingTile(FileSystemEntity recording) {
    final fileName = recording.path.split('/').last;
    final stat = recording.statSync();
    final size = (stat.size / 1024 / 1024).toStringAsFixed(2);
    final date = stat.modified;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const Icon(Icons.audiotrack, size: 40, color: Colors.blue),
        title: Text(
          fileName,
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '$size MB • ${_formatDate(date)}',
          style: const TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Delete recording',
          onPressed: () => _confirmDelete(recording),
        ),
        onTap: () async {
          final accessibility = context.read<AccessibilityService>();
          await accessibility.speak('Selected $fileName');
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmDelete(FileSystemEntity recording) async {
    final fileName = recording.path.split('/').last;
    final accessibility = context.read<AccessibilityService>();
    await accessibility.speak('Confirm delete $fileName');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recording'),
        content: Text('Are you sure you want to delete "$fileName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _recordingService.deleteRecording(recording.path);
      await accessibility.speak('Recording deleted');
      await _loadRecordings();
    }
  }

  @override
  void dispose() {
    _recordingService.dispose();
    super.dispose();
  }
}
