class PracticeSessionResult {
  final String sessionId;
  final int totalQuestions;
  final int completed;
  final String? strengths;
  final String? weaknesses;
  final int finalScore;
  final int createdAt; // you can also wrap this as DateTime

  PracticeSessionResult({
    required this.sessionId,
    required this.totalQuestions,
    required this.completed,
    this.strengths,
    this.weaknesses,
    required this.finalScore,
    required this.createdAt,
  });
}
