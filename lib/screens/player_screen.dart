import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../services/accessibility_service.dart';
import '../services/recording_service.dart';
import '../models/radio_station.dart';

class PlayerScreen extends StatefulWidget {
  final RadioStation station;

  const PlayerScreen({super.key, required this.station});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final RecordingService _recordingService = RecordingService();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accessibility = context.read<AccessibilityService>();
      accessibility.announceNavigation('Player');
      _startPlayback();
    });
  }

  Future<void> _startPlayback() async {
    final radioProvider = context.read<RadioProvider>();
    final accessibility = context.read<AccessibilityService>();
    
    await radioProvider.playStation(widget.station);
    await accessibility.announcePlaybackState('Playing', widget.station.name);
  }

  @override
  void dispose() {
    _recordingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
      ),
      body: Consumer<RadioProvider>(
        builder: (context, radioProvider, child) {
          final isPlaying = radioProvider.playerState == PlayerState.playing;
          final isLoading = radioProvider.playerState == PlayerState.loading;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Station icon
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.radio,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // Station name
                Text(
                  widget.station.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Stream URL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    widget.station.url,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 48),

                // Loading indicator
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  // Play/Pause button
                  IconButton(
                    iconSize: 80,
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => _togglePlayback(radioProvider),
                  ),

                const SizedBox(height: 24),

                // Recording button
                ElevatedButton.icon(
                  onPressed: () => _toggleRecording(),
                  icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
                  label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording ? Colors.red : null,
                    foregroundColor: _isRecording ? Colors.white : null,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),

                if (_isRecording)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Recording...',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ],
                    ),
                  ),

                if (radioProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      radioProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _togglePlayback(RadioProvider radioProvider) async {
    final accessibility = context.read<AccessibilityService>();

    if (radioProvider.playerState == PlayerState.playing) {
      await radioProvider.pausePlayback();
      await accessibility.announcePlaybackState('Paused', null);
    } else {
      await radioProvider.resumePlayback();
      await accessibility.announcePlaybackState('Playing', widget.station.name);
    }
  }

  Future<void> _toggleRecording() async {
    final accessibility = context.read<AccessibilityService>();

    if (_isRecording) {
      final path = await _recordingService.stopRecording();
      setState(() {
        _isRecording = false;
      });
      await accessibility.announceRecordingState('stopped');
      
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording saved: ${path.split('/').last}')),
        );
      }
    } else {
      try {
        await _recordingService.startRecording(widget.station.name);
        setState(() {
          _isRecording = true;
        });
        await accessibility.announceRecordingState('started');
      } catch (e) {
        await accessibility.announceError('Failed to start recording');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
