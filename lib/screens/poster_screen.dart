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
  final Color primaryPink = const Color.fromARGB(255, 235, 114, 154);

  Widget _buildSection(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryPink,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    if (items.isEmpty) {
      return Text(
        'No items available.',
        style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 18, color: primaryPink),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 15)),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: primaryPink,
        foregroundColor: Colors.white,
        title: const Text(
          'Your Event Plan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Task 2.4: Display AI-generated poster
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              ),
              // Task 3.4 + Task 4: Display AI-generated suggestions
              _buildSection(
                'Summary',
                Text(
                  suggestion.summary,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
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
                      'RM ${suggestion.budgetRM.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              _buildSection('Schedule', _buildBulletList(suggestion.schedule)),
              _buildSection('Decor Ideas', _buildBulletList(suggestion.decor)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
