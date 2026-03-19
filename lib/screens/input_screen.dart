import 'package:ass1_event/models/event_suggestion.dart';
import 'package:ass1_event/services/image_generation_service.dart';
import 'package:ass1_event/services/suggestion_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'poster_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key, required this.title});

  final String title;

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController themeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  final TextEditingController styleController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    themeController.dispose();
    locationController.dispose();
    durationController.dispose();
    budgetController.dispose();
    participantsController.dispose();
    styleController.dispose();
    super.dispose();
  }

  Future<void> _generateEventPlan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final String eventName = eventNameController.text.isNotEmpty
          ? eventNameController.text
          : 'Summer Gala';
      final String theme = themeController.text.isNotEmpty
          ? themeController.text
          : 'Tech Talk';
      final String location = locationController.text.isNotEmpty
          ? locationController.text
          : 'Campus Hall';
      final int durationHours = int.tryParse(durationController.text) ?? 3;
      final double budgetRM = double.tryParse(budgetController.text) ?? 1500.0;
      final int participants = int.tryParse(participantsController.text) ?? 50;
      final String style = styleController.text.isNotEmpty
          ? styleController.text
          : 'Modern';

      final String imagePrompt =
          'A professional event poster for a $theme titled "$eventName" held at $location for $participants participants over $durationHours hours with a budget of RM${budgetRM.toStringAsFixed(0)}. Design style: $style.';

      final results = await Future.wait([
        ImageGenerationService.generateImage(imagePrompt),
        SuggestionService.generateSuggestion(
          eventName: eventName,
          theme: theme,
          location: location,
          durationHours: durationHours,
          budgetRM: budgetRM,
          participants: participants,
        ),
      ]);

      final image = results[0] as Uint8List;
      final EventSuggestion suggestion = results[1] as EventSuggestion;

      if (mounted) {
        Navigator.pop(context); // Close loading indicator
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(image: image, suggestion: suggestion),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to generate plan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 114, 154),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: eventNameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  prefixIcon: Icon(Icons.event),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: themeController,
                decoration: const InputDecoration(
                  labelText: 'Event Theme',
                  prefixIcon: Icon(Icons.lightbulb),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Event Location',
                  prefixIcon: Icon(Icons.place),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Event Duration (hours)',
                  prefixIcon: Icon(Icons.timer),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Event Budget (RM)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: participantsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Expected Participants',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: styleController,
                decoration: const InputDecoration(
                  labelText: 'Poster Style',
                  prefixIcon: Icon(Icons.style),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: MaterialButton(
                  color: const Color.fromARGB(255, 216, 81, 81),
                  onPressed: _generateEventPlan,
                  child: const Text(
                    'GENERATE EVENT PLAN',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
