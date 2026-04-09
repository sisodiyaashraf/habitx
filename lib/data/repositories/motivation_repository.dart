import 'dart:math';

class MotivationRepository {
  final List<String> _quotes = [
    "Excellence is not an exception, it is a prevailing attitude.",
    "The secret of your future is hidden in your daily routine.",
    "Small steps lead to big changes. Keep going!",
    "Your habits define your future version. Level up today!",
  ];

  String getRandomMotivation() {
    return _quotes[Random().nextInt(_quotes.length)];
  }
}
