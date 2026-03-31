import 'dart:async';
import 'package:flutter/material.dart';
import '../data/typing_tests.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/results_storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _controller = TextEditingController();

  Timer? _timer;
  int _elapsedSeconds = 0;
  int _currentTestIndex = 0;
  int _score = 0;
  String resultMessage = '';
  bool _isFinished = false;

  TypingTestItem get currentTest => typingTests[_currentTestIndex];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isFinished) {
        setState(() {
          _elapsedSeconds++;
        });
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

  final FocusNode _focusNode = FocusNode();

  void _submitTest() async {
    if (_isFinished) return;

    final typedText = _normalizeText(_controller.text);
    final targetText = _normalizeText(currentTest.sentence);

    if (typedText == targetText) {
      if (_currentTestIndex < typingTests.length - 1) {
        setState(() {
          _score++;
          _currentTestIndex++;
          resultMessage = 'Correct! Proceed to the next test.';
          _controller.clear();
          _focusNode.requestFocus();
        });
      } else {
        setState(() {
          _score++;
          _isFinished = true;
          resultMessage = 'You finished all 10 typing tests.';
        });
        _timer?.cancel();

        await ResultsStorage.saveResult(
          TestResult(
            score: _score,
            totalItems: typingTests.length,
            elapsedSeconds: _elapsedSeconds,
            dateTime: DateTime.now(),
          ),
        );
      }
    } else {
      setState(() {
        resultMessage = 'Typed text does not match. \n Please try again.';
      });
    }
  }

  void _endTest() async {
    setState(() {
      _isFinished = true;
      resultMessage = 'Test ended.';
    });
    _timer?.cancel();

    await ResultsStorage.saveResult(
      TestResult(
        score: _score,
        totalItems: typingTests.length,
        elapsedSeconds: _elapsedSeconds,
        dateTime: DateTime.now(),
      ),
    );
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
    final testNumber = _currentTestIndex + 1;

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
                            const SizedBox(height: 120),

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
                                        fontSize: 36,
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
                                const SizedBox(width: 50),
                                Column(
                                  children: [
                                    Text(
                                      _formatTime(_elapsedSeconds),
                                      style: GoogleFonts.figtree(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF7A5A68),
                                      ),
                                    ),
                                    Text(
                                      'min/sec',
                                      style: GoogleFonts.figtree(
                                        fontSize: 14,
                                        color: const Color(0xFF7A5A68),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                                    'Back',
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
                                'Test $testNumber: ${currentTest.level}\n${_formatTime(_elapsedSeconds)}',
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
                                  child: const Text(
                                    'DONE',
                                    style: TextStyle(
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF7A5A68),
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
                                  child: const Text(
                                    'END TEST',
                                    style: TextStyle(
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
