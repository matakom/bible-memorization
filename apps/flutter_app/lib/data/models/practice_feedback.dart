enum GameType {
  flashcard,
  wordChoice,
  firstLetterTyping,
  referenceMatch,
  verseBuilder
}

class PracticeFeedback {
  final String verseId;
  final int grade; // 0-5
  final int durationSeconds;
  final GameType gameType;

  PracticeFeedback({
    required this.verseId,
    required this.grade,
    required this.durationSeconds,
    required this.gameType,
  });
}