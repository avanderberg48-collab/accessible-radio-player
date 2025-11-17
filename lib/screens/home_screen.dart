import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../services/accessibility_service.dart';
import '../models/radio_station.dart';
import 'add_edit_station_screen.dart';
import 'player_screen.dart';
import 'recordings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accessibility = context.read<AccessibilityService>();
      accessibility.announceNavigation('Home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music),
            tooltip: 'Recordings',
            onPressed: () async {
              final accessibility = context.read<AccessibilityService>();
              await accessibility.speak('Opening recordings');
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecordingsScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<RadioProvider>(
        builder: (context, radioProvider, child) {
          if (radioProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (radioProvider.errorMessage != null) {
            return Center(
              child: Text(
                radioProvider.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          final stations = radioProvider.stations;

          if (stations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.radio, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No radio stations yet',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Station'),
                    onPressed: () => _navigateToAddStation(context),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              final station = stations[index];
              return _buildStationTile(context, station, radioProvider);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddStation(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Station'),
      ),
    );
  }

  Widget _buildStationTile(
    BuildContext context,
    RadioStation station,
    RadioProvider radioProvider,
  ) {
    final accessibility = context.read<AccessibilityService>();
    final isPlaying = radioProvider.currentStation?.id == station.id &&
        radioProvider.playerState == PlayerState.playing;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(
          isPlaying ? Icons.play_circle_filled : Icons.radio,
          size: 40,
          color: isPlaying ? Colors.green : Colors.blue,
        ),
        title: Text(
          station.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          station.url,
          style: const TextStyle(fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                station.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: station.isFavorite ? Colors.red : null,
              ),
              tooltip: 'Toggle favorite',
              onPressed: () async {
                await radioProvider.toggleFavorite(station.id);
                await accessibility.speak(
                  station.isFavorite ? 'Removed from favorites' : 'Added to favorites',
                );
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  await accessibility.speak('Edit station');
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditStationScreen(station: station),
                      ),
                    );
                  }
                } else if (value == 'delete') {
                  await _confirmDelete(context, station, radioProvider);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () async {
          await accessibility.announceStationSelected(station.name);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerScreen(station: station),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    RadioStation station,
    RadioProvider radioProvider,
  ) async {
    final accessibility = context.read<AccessibilityService>();
    await accessibility.speak('Confirm delete ${station.name}');

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Station'),
        content: Text('Are you sure you want to delete "${station.name}"?'),
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
      await radioProvider.deleteStation(station.id);
      await accessibility.speak('Station deleted');
    }
  }

  void _navigateToAddStation(BuildContext context) async {
    final accessibility = context.read<AccessibilityService>();
    await accessibility.speak('Add new station');
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddEditStationScreen()),
      );
    }
  }
}
