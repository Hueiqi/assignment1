class EventSuggestion {
  EventSuggestion({
    required this.eventName,
    required this.theme,
    required this.location,
    required this.durationHours,
    required this.budgetRM,
    required this.participants,
    required this.summary,
    required this.schedule,
    required this.decor,
    required this.foodAndBeverage,
    required this.budgetBreakdown,
  });

  final String eventName;
  final String theme;
  final String location;
  final int durationHours;
  final double budgetRM;
  final int participants;
  final String summary;
  final List<String> schedule;
  final List<String> decor;
  final List<String> foodAndBeverage;
  final Map<String, String> budgetBreakdown;

  factory EventSuggestion.fromJson(Map<String, dynamic> json) {
    final event = json['event'] as Map<String, dynamic>? ?? {}; // fallback

    return EventSuggestion(
      eventName: event['name']?.toString() ?? '',
      theme: event['theme']?.toString() ?? '',
      location: event['location']?.toString() ?? '',
      durationHours: (event['duration_hours'] as num?)?.toInt() ?? 0,
      budgetRM: (event['budget_rm'] as num?)?.toDouble() ?? 0.0,
      participants: (event['participants'] as num?)?.toInt() ?? 0,
      summary: json['summary']?.toString() ?? '',
      schedule:
          (json['schedule'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      decor:
          (json['decor'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      foodAndBeverage:
          (json['food_and_beverage'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      budgetBreakdown:
          (json['budget_breakdown'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value?.toString() ?? ''),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': {
        'name': eventName,
        'theme': theme,
        'location': location,
        'duration_hours': durationHours,
        'budget_rm': budgetRM,
        'participants': participants,
      },
      'summary': summary,
      'schedule': schedule,
      'decor': decor,
      'food_and_beverage': foodAndBeverage,
      'budget_breakdown': budgetBreakdown,
    };
  }
}
