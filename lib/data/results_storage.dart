import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TestResult {
  final int score;
  final int totalItems;
  final int elapsedSeconds;
  final DateTime dateTime;

  TestResult({
    required this.score,
    required this.totalItems,
    required this.elapsedSeconds,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
    'score': score,
    'totalItems': totalItems,
    'elapsedSeconds': elapsedSeconds,
    'dateTime': dateTime.toIso8601String(),
  };

  factory TestResult.fromJson(Map<String, dynamic> json) => TestResult(
    score: json['score'],
    totalItems: json['totalItems'],
    elapsedSeconds: json['elapsedSeconds'],
    dateTime: DateTime.parse(json['dateTime']),
  );
}

class ResultsStorage {
  static const _key = 'test_results';

  static Future<void> saveResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getResults();
    existing.insert(0, result);
    final encoded = existing.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  static Future<List<TestResult>> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => TestResult.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> clearResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
