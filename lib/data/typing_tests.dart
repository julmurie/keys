class TypingTestItem {
  final String level;
  final String sentence;

  const TypingTestItem({required this.level, required this.sentence});
}

const List<TypingTestItem> typingTests = [
  TypingTestItem(level: 'Easy', sentence: 'Practice makes perfect.'),
  TypingTestItem(level: 'Easy', sentence: 'Time and tide wait for no man.'),
  TypingTestItem(
    level: 'Easy',
    sentence: 'Where there is a will, there is a way.',
  ),
  TypingTestItem(
    level: 'Medium',
    sentence: 'A journey of a thousand miles begins with a single step.',
  ),
  TypingTestItem(
    level: 'Medium',
    sentence: 'Look before you leap, and think before you speak.',
  ),
  TypingTestItem(
    level: 'Medium',
    sentence: 'Better late than never, but never late is better.',
  ),
  TypingTestItem(
    level: 'Medium',
    sentence: 'She sells seashells by the seashore on sunny summer days.',
  ),
  TypingTestItem(
    level: 'Hard',
    sentence:
        'Peter Piper picked a peck of pickled peppers before the picnic began.',
  ),
  TypingTestItem(
    level: 'Hard',
    sentence:
        'A big black bear sat on a big black rug and stared into the bright blue sky.',
  ),
  TypingTestItem(
    level: 'Hard',
    sentence:
        'If two witches were watching two watches, which witch would watch which watch first?',
  ),
];
