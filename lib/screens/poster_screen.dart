import 'package:ass1_event/models/event_suggestion.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.image,
    required this.suggestion,
  });

  final Uint8List image;
  final EventSuggestion suggestion;

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildKeyValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 182, 122, 211),
        foregroundColor: Colors.white,
        title: const Text('EVENT PLAN RESULTS'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
              _buildSection(
                'Summary',
                Text(suggestion.summary, style: const TextStyle(fontSize: 16)),
              ),
              _buildSection(
                'Event Details',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKeyValueRow('Name', suggestion.eventName),
                    _buildKeyValueRow('Theme', suggestion.theme),
                    _buildKeyValueRow('Location', suggestion.location),
                    _buildKeyValueRow(
                      'Duration',
                      '${suggestion.durationHours} hours',
                    ),
                    _buildKeyValueRow(
                      'Participants',
                      suggestion.participants.toString(),
                    ),
                    _buildKeyValueRow(
                      'Budget',
                      'RM${suggestion.budgetRM.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),
              _buildSection('Schedule', _buildBulletList(suggestion.schedule)),
              _buildSection(
                'Decor Suggestions',
                _buildBulletList(suggestion.decor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
