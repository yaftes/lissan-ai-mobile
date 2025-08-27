part of 'practice_speaking_bloc.dart';

enum BlocStatus {
  initial,
  loading,
  sessionStarted,
  sessionEnded,
  questionsLoaded,
  feedbackReceived,
  error,
}

class PracticeSpeakingState extends Equatable {
  final BlocStatus status;
  final dynamic session; // replace with real Session entity
  final InterviewQuestion? questions;
  final dynamic feedback; // replace with real Feedback entity
  final String? error;

  // speech-to-text fields
  final String recognizedText;
  final bool isListening;

  const PracticeSpeakingState({
    this.status = BlocStatus.initial,
    this.session,
    this.questions,
    this.feedback,
    this.error,
    this.recognizedText = '',
    this.isListening = false,
  });

  PracticeSpeakingState copyWith({
    BlocStatus? status,
    dynamic session,
    InterviewQuestion? questions,
    dynamic feedback,
    String? error,
    String? recognizedText,
    bool? isListening,
  }) {
    return PracticeSpeakingState(
      status: status ?? this.status,
      session: session ?? this.session,
      questions: questions ?? this.questions,
      feedback: feedback ?? this.feedback,
      error: error,
      recognizedText: recognizedText ?? this.recognizedText,
      isListening: isListening ?? this.isListening,
    );
  }

  @override
  List<Object?> get props =>
      [status, session, questions, feedback, error, recognizedText, isListening];
}
