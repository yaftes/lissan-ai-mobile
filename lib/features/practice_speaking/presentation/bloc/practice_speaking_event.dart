part of 'practice_speaking_bloc.dart';

abstract class PracticeSpeakingEvent extends Equatable {
  const PracticeSpeakingEvent();
  @override
  List<Object?> get props => [];
}

// Session events
class StartPracticeSessionEvent extends PracticeSpeakingEvent {
  final String type;
  const StartPracticeSessionEvent({required this.type});
}

class EndPracticeSessionEvent extends PracticeSpeakingEvent {
  final String sessionId;
  const EndPracticeSessionEvent({required this.sessionId});
}

class GetInterviewQuestionsEvent extends PracticeSpeakingEvent {
  final String type;
  const GetInterviewQuestionsEvent({required this.type});
}

class SubmitAnswerEvent extends PracticeSpeakingEvent {
  final UserAnswer answer;
  const SubmitAnswerEvent(this.answer);

  @override
  List<Object?> get props => [answer];
}

// Speech-to-text events
class InitSpeechEvent extends PracticeSpeakingEvent {}
class StartListeningEvent extends PracticeSpeakingEvent {}
class StopListeningEvent extends PracticeSpeakingEvent {}

class SpeechResultEvent extends PracticeSpeakingEvent {
  final String recognizedWords;
  const SpeechResultEvent(this.recognizedWords);
  @override
  List<Object?> get props => [recognizedWords];
}

class SpeechErrorEvent extends PracticeSpeakingEvent {
  final String message;
  const SpeechErrorEvent(this.message);
  @override
  List<Object?> get props => [message];
}
