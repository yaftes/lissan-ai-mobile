abstract class GrammarEvent {}

class CheckGrammarEvent extends GrammarEvent {
  final String englishText;

  CheckGrammarEvent({required this.englishText});
}
