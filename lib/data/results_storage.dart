import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TestResult {
  final int score;
  final int totalItems;
  final int elapsedSeconds;
  final double wpm;
  final DateTime dateTime;

  TestResult({
    required this.score,
    required this.totalItems,
    required this.elapsedSeconds,
    required this.wpm,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'totalItems': totalItems,
      'elapsedSeconds': elapsedSeconds,
      'wpm': wpm,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory TestResult.fromMap(Map<String, dynamic> map) {
    return TestResult(
      score: map['score'] ?? 0,
      totalItems: map['totalItems'] ?? 0,
      elapsedSeconds: map['elapsedSeconds'] ?? 0,
      wpm: (map['wpm'] ?? 0).toDouble(),
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}

class ResultsStorage {
  static const String _key = 'typing_test_results';

  static Future<void> saveResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final results = await getResults();
    results.insert(0, result);

    final encoded = results.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

  static Future<List<TestResult>> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key) ?? [];

    return stored.map((item) => TestResult.fromMap(jsonDecode(item))).toList();
  }

  static Future<void> clearResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
