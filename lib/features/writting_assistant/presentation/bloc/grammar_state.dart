import 'package:lissan_ai/features/writting_assistant/domain/entities/grammar_result.dart';

abstract class GrammarState {}

class GrammarInitial extends GrammarState {}

class GrammarLoading extends GrammarState {}

class GrammarLoaded extends GrammarState {
  final GrammarResult grammarResult;

  GrammarLoaded({required this.grammarResult});
}

class GrammarError extends GrammarState {
  final String message;

  GrammarError({required this.message});
}
