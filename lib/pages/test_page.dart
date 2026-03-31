import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/typing_tests.dart';
import '../data/results_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static const int _totalCountdownSeconds = 120;

  Timer? _timer;
  int _remainingSeconds = _totalCountdownSeconds;
  int _currentTestIndex = 0;
  int _score = 0;
  int _correctCharactersTyped = 0;
  String resultMessage = '';
  bool _isFinished = false;
  bool _resultSaved = false;

  TypingTestItem get currentTest => typingTests[_currentTestIndex];

  int get _usedSeconds => _totalCountdownSeconds - _remainingSeconds;

  int get _currentTestNumber => _currentTestIndex + 1;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isFinished) return;

      if (_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _finishTest('Time is up.');
      }
    });
  }

  String _formatDateTime() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final hour = now.hour > 12
        ? now.hour - 12
        : now.hour == 0
        ? 12
        : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'pm' : 'am';

    return '${months[now.month - 1]} ${now.day}, ${now.year}  $hour:$minute$period';
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _normalizeText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  double _calculateWpm() {
    final minutes = _usedSeconds / 60;
    if (minutes <= 0) return 0;
    return (_correctCharactersTyped / 5) / minutes;
  }

  Future<void> _saveResultIfNeeded() async {
    if (_resultSaved) return;
    _resultSaved = true;

    await ResultsStorage.saveResult(
      TestResult(
        score: _score,
        totalItems: typingTests.length,
        elapsedSeconds: _usedSeconds,
        wpm: _calculateWpm(),
        dateTime: DateTime.now(),
      ),
    );
  }

  Future<void> _finishTest(String message) async {
    if (_isFinished) return;

    setState(() {
      _isFinished = true;
      resultMessage = message;
      if (_remainingSeconds < 0) {
        _remainingSeconds = 0;
      }
    });

    _timer?.cancel();
    await _saveResultIfNeeded();
  }

  Widget _buildTypingProgressText() {
    final targetText = currentTest.sentence;
    final typedText = _controller.text;
    final spans = <TextSpan>[];

    for (var i = 0; i < targetText.length; i++) {
      final isTyped = i < typedText.length;
      final isCorrect = isTyped && typedText[i] == targetText[i];

      spans.add(
        TextSpan(
          text: targetText[i],
          style: TextStyle(
            color: isTyped
                ? (isCorrect
                      ? const Color(0xFF7A5A68)
                      : const Color(0xFFD64545))
                : const Color(0xFFE8B9CE),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (typedText.length > targetText.length) {
      spans.add(
        TextSpan(
          text: typedText.substring(targetText.length),
          style: const TextStyle(
            color: Color(0xFFD64545),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: GoogleFonts.figtree(fontSize: 24), children: spans),
    );
  }

  Future<void> _submitTest() async {
    if (_isFinished) return;

    final typedText = _normalizeText(_controller.text);
    final targetText = _normalizeText(currentTest.sentence);

    if (typedText == targetText) {
      _correctCharactersTyped += targetText.length;

      if (_currentTestIndex < typingTests.length - 1) {
        setState(() {
          _score++;
          _currentTestIndex++;
          resultMessage = 'Correct! Proceed to the next test.';
          _controller.clear();
        });
        _focusNode.requestFocus();
      } else {
        setState(() {
          _score++;
          resultMessage = 'You finished all 10 typing tests.';
        });
        await _finishTest('You finished all 10 typing tests.');
      }
    } else {
      setState(() {
        resultMessage = 'Typed text does not match.\nPlease try again.';
      });
    }
  }

  Future<void> _endTest() async {
    await _finishTest('Test ended.');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wpm = _calculateWpm().toStringAsFixed(1);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 247, 247),
              Color.fromRGBO(238, 205, 221, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/keys_logo_title.png', height: 65),
                const SizedBox(height: 50),
                Expanded(
                  child: _isFinished
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 100),
                            Center(
                              child: Text(
                                'Well Done!',
                                style: GoogleFonts.figtree(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: const Color.fromARGB(
                                    255,
                                    190,
                                    122,
                                    157,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                _formatDateTime(),
                                style: GoogleFonts.figtree(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF7A5A68),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '$_score/${typingTests.length}',
                                      style: GoogleFonts.figtree(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF7A5A68),
                                      ),
                                    ),
                                    Text(
                                      'points',
                                      style: GoogleFonts.figtree(
                                        fontSize: 14,
                                        color: const Color(0xFF7A5A68),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 35),
                                Column(
                                  children: [
                                    Text(
                                      _formatTime(_usedSeconds),
                                      style: GoogleFonts.figtree(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF7A5A68),
                                      ),
                                    ),
                                    Text(
                                      'time used',
                                      style: GoogleFonts.figtree(
                                        fontSize: 14,
                                        color: const Color(0xFF7A5A68),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 35),
                                Column(
                                  children: [
                                    Text(
                                      wpm,
                                      style: GoogleFonts.figtree(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF7A5A68),
                                      ),
                                    ),
                                    Text(
                                      'wpm',
                                      style: GoogleFonts.figtree(
                                        fontSize: 14,
                                        color: const Color(0xFF7A5A68),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                resultMessage,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.figtree(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF7A5A68),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: SizedBox(
                                width: 90,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC98AA6),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                  ),
                                  child: Text(
                                    'BACK',
                                    style: GoogleFonts.figtree(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Test $_currentTestNumber / ${typingTests.length}\n${currentTest.level} • ${_formatTime(_remainingSeconds)}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.figtree(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF7A5A68),
                                ),
                              ),
                            ),
                            const SizedBox(height: 100),
                            Center(child: _buildTypingProgressText()),
                            const SizedBox(height: 80),
                            Center(
                              child: SizedBox(
                                width: 290,
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  autofocus: true,
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Type here...',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFC98AA6),
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFC98AA6),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: _submitTest,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: const Color(0xFFC98AA6),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  child: Text(
                                    'DONE',
                                    style: GoogleFonts.figtree(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 70),
                            Center(
                              child: Text(
                                resultMessage,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.figtree(
                                  fontSize: 16,
                                  color: const Color(0xFF7A5A68),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                  onPressed: _endTest,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7A5A68),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(
                                    'END TEST',
                                    style: GoogleFonts.figtree(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
