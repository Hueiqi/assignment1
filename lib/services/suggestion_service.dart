import '../models/event_suggestion.dart';

class SuggestionService {
  static Future<EventSuggestion> generateSuggestion({
    required String eventName,
    required String theme,
    required String location,
    required int durationHours,
    required double budgetRM,
    required int participants,
  }) async {
    // Simulate an external call latency.
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final Map<String, dynamic> suggestion = {
      'event': {
        'name': eventName,
        'theme': theme,
        'location': location,
        'duration_hours': durationHours,
        'budget_rm': budgetRM,
        'participants': participants,
      },
      'summary':
          'Plan a $theme event called "$eventName" at $location for $participants people over $durationHours hours with a budget of RM${budgetRM.toStringAsFixed(0)}.',
      'schedule': _buildSchedule(durationHours),
      'decor': _buildDecorSuggestions(theme),
      'food_and_beverage': _buildFoodSuggestions(participants),
      'budget_breakdown': {
        'venue': (budgetRM * 0.35).toStringAsFixed(0),
        'food': (budgetRM * 0.25).toStringAsFixed(0),
        'entertainment': (budgetRM * 0.20).toStringAsFixed(0),
        'misc': (budgetRM * 0.20).toStringAsFixed(0),
      },
    };

    return EventSuggestion.fromJson(suggestion);
  }

  static List<String> _buildSchedule(int durationHours) {
    final List<String> schedule = [
      'Welcome & registration (15 min)',
      'Opening remarks (10 min)',
      'Key session 1 (45 min)',
      'Coffee break (15 min)',
      'Key session 2 (45 min)',
    ];

    if (durationHours >= 4) {
      schedule.add('Networking & refreshments (30 min)');
    }
    if (durationHours >= 6) {
      schedule.add('Panel discussion / breakout sessions (45 min)');
    }

    schedule.add('Closing & wrap-up (15 min)');
    return schedule;
  }

  static List<String> _buildDecorSuggestions(String theme) {
    return [
      'Use a color palette that matches the "$theme" theme.',
      'Add themed signage and banners at the entrance.',
      'Use lighting to create ambiance, e.g., string lights or spotlights.',
      'Include a photo wall or backdrop for attendees to take pictures.',
    ];
  }

  static List<String> _buildFoodSuggestions(int participants) {
    if (participants <= 30) {
      return [
        'Offer a sit-down meal with a set menu.',
        'Include a vegetarian and vegan option.',
        'Provide a small dessert station or cake.',
      ];
    }

    return [
      'Offer a buffet-style spread with multiple stations.',
      'Include finger foods and easy-to-eat snacks.',
      'Provide a beverage station with water, soft drinks, and coffee/tea.',
    ];
  }
}
