class FeedbackPoint {
  final String type;
  final String focusPhrase;
  final String suggestion;

  FeedbackPoint({
    required this.type,
    required this.focusPhrase,
    required this.suggestion,
  });
}

class AnswerFeedback {
  final String overallSummary;
  final List<FeedbackPoint> feedbackPoints;

  AnswerFeedback({
    required this.overallSummary,
    required this.feedbackPoints,
  });
}
