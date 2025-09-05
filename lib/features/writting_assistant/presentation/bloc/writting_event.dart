abstract class WrittingEvent {}

class CheckGrammarEvent extends WrittingEvent {
  final String englishText;

  CheckGrammarEvent({required this.englishText});
}

class GenerateEmailDraft extends WrittingEvent {
  final String amharicPrompt;
  final String tone;
  final String type;

  GenerateEmailDraft(this.amharicPrompt, this.tone, this.type);

  @override
  List<Object> get props => [amharicPrompt, tone, type];
}

class ImproveEmailEvent extends WrittingEvent {
  final String userEmail;
  final String tone;
  final String type;

  ImproveEmailEvent(this.userEmail, this.tone, this.type);

  @override
  List<Object> get props => [userEmail, tone, type];
}


// save email
class SaveEmailDraftEvent extends WrittingEvent {
  final String subject;
  final String body;

  SaveEmailDraftEvent({required this.subject, required this.body});
}

class SaveImprovedEmailEvent extends WrittingEvent {
  final String subject;
  final String body;

  SaveImprovedEmailEvent({required this.subject, required this.body});
}
