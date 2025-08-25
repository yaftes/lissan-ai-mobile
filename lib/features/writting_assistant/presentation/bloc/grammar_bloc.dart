import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lissan_ai/features/writting_assistant/domain/usecases/check_grammar_usecase.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/grammar_event.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/grammar_state.dart';

class GrammarBloc extends Bloc<GrammarEvent, GrammarState> {
  final CheckGrammarUsecase checkGrammarUsecase;
  GrammarBloc({required this.checkGrammarUsecase}) : super(GrammarInitial()) {
    on<CheckGrammarEvent>((event, emit) async {
      emit(GrammarLoading());
      final result = await checkGrammarUsecase(event.englishText);
      result.fold(
        (failure) => emit(GrammarError(message: failure.message)),
        (success) => emit(GrammarLoaded(grammarResult: success)),
      );
    });
  }
}
