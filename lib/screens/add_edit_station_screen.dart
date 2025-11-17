import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../services/accessibility_service.dart';
import '../models/radio_station.dart';

class AddEditStationScreen extends StatefulWidget {
  final RadioStation? station;

  const AddEditStationScreen({super.key, this.station});

  @override
  State<AddEditStationScreen> createState() => _AddEditStationScreenState();
}

class _AddEditStationScreenState extends State<AddEditStationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.station?.name ?? '');
    _urlController = TextEditingController(text: widget.station?.url ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accessibility = context.read<AccessibilityService>();
      accessibility.announceNavigation(
        widget.station == null ? 'Add Station' : 'Edit Station',
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.station != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Station' : 'Add Station'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Station Name',
                  hintText: 'e.g., BBC Radio 1',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.radio),
                ),
                style: const TextStyle(fontSize: 18),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a station name';
                  }
                  return null;
                },
                onTap: () async {
                  final accessibility = context.read<AccessibilityService>();
                  await accessibility.speak('Station name field');
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Stream URL',
                  hintText: 'https://example.com/stream.mp3',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a stream URL';
                  }
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return 'URL must start with http:// or https://';
                  }
                  return null;
                },
                onTap: () async {
                  final accessibility = context.read<AccessibilityService>();
                  await accessibility.speak('Stream URL field');
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveStation,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Update Station' : 'Add Station'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveStation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final url = _urlController.text.trim();
    final radioProvider = context.read<RadioProvider>();
    final accessibility = context.read<AccessibilityService>();

    try {
      if (widget.station == null) {
        await radioProvider.addStation(name, url);
        await accessibility.speak('Station added successfully');
      } else {
        await radioProvider.updateStation(widget.station!.id, name, url);
        await accessibility.speak('Station updated successfully');
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      await accessibility.announceError('Failed to save station');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
