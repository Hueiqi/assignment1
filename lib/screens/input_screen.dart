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

  final Color primaryPink = const Color.fromARGB(255, 235, 114, 154);

  @override
  void dispose() {
    eventNameController.dispose();
    themeController.dispose();
    locationController.dispose();
    durationController.dispose();
    budgetController.dispose();
    participantsController.dispose();
    super.dispose();
  }

  Future<void> _generateEventPlan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: primaryPink)),
    );

    try {
      final String eventName = eventNameController.text.isNotEmpty
          ? eventNameController.text
          : 'Campus Fiesta';
      final String theme = themeController.text.isNotEmpty
          ? themeController.text
          : 'Student Gathering';
      final String location = locationController.text.isNotEmpty
          ? locationController.text
          : 'Main Hall';
      final int durationHours = int.tryParse(durationController.text) ?? 3;
      final double budgetRM = double.tryParse(budgetController.text) ?? 500.0;
      final int participants = int.tryParse(participantsController.text) ?? 50;

      final String imagePrompt =
          'A professional, modern event poster for a student $theme event titled '
          '"$eventName" held at $location for $participants participants over '
          '$durationHours hours. Bright, friendly campus life aesthetic.';

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

      final Uint8List image = results[0] as Uint8List;
      final EventSuggestion suggestion = results[1] as EventSuggestion;

      if (mounted) {
        Navigator.pop(context);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oops! Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildFriendlyTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: primaryPink),
          filled: true,
          // ignore: deprecated_member_use
          fillColor: primaryPink.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            // ignore: deprecated_member_use
            borderSide: BorderSide(color: primaryPink.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: primaryPink, width: 2),
          ),
          floatingLabelStyle: TextStyle(color: primaryPink),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryPink,
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "plan a campus event! ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildFriendlyTextField(
                controller: eventNameController,
                labelText: 'Event Name',
                icon: Icons.celebration,
              ),
              _buildFriendlyTextField(
                controller: themeController,
                labelText: 'Event Theme (e.g. Tech Talk)',
                icon: Icons.lightbulb_outline,
              ),
              _buildFriendlyTextField(
                controller: locationController,
                labelText: 'Event Location (e.g. Hall, Outdoor)',
                icon: Icons.place_outlined,
              ),
              _buildFriendlyTextField(
                controller: durationController,
                labelText: 'Event Duration (hours)',
                icon: Icons.timer_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _buildFriendlyTextField(
                controller: budgetController,
                labelText: 'Event Budget (RM)',
                icon: Icons.attach_money,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
              _buildFriendlyTextField(
                controller: participantsController,
                labelText: 'Expected Participants',
                icon: Icons.people_outline,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _generateEventPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'GENERATE PLAN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
