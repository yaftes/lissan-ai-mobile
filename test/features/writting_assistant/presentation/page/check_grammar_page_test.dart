import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lissan_ai/features/writting_assistant/domain/entities/correction.dart';
import 'package:lissan_ai/features/writting_assistant/domain/entities/explanation.dart';
import 'package:lissan_ai/features/writting_assistant/domain/entities/grammar_result.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/check_grammar_page.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_bloc.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_state.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_event.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockWrittingBloc extends Mock implements WrittingBloc {}
class FakeWrittingEvent extends Fake implements WrittingEvent {}
class FakeWrittingState extends Fake implements WrittingState {}

void main() {
  late MockWrittingBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWrittingEvent());
    registerFallbackValue(FakeWrittingState());
  });

  setUp(() {
    mockBloc = MockWrittingBloc();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<WrittingBloc>.value(
        value: mockBloc,
        child: child,
      ),
    );
  }

  testWidgets('renders CheckGrammarPage with initial text', (tester) async {
    when(() => mockBloc.state).thenReturn(WrittingInitial());

    await tester.pumpWidget(makeTestableWidget(
      const CheckGrammarPage(initialText: 'Hello world'),
    ));

    expect(find.text('Hello world'), findsOneWidget);
    expect(find.text('Check Grammar'), findsOneWidget);

    // Auto-check should trigger event if autoCheck is true
    when(() => mockBloc.add(any())).thenReturn(null);
    await tester.pump();
  });

  testWidgets('check grammar button triggers event when text entered', (tester) async {
    when(() => mockBloc.state).thenReturn(WrittingInitial());
    when(() => mockBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(makeTestableWidget(const CheckGrammarPage()));

    // Enter text
    await tester.enterText(find.byType(TextField), 'Test sentence');
    await tester.pump();

    // Tap button
    await tester.tap(find.text('Check Grammar'));
    await tester.pump();

    verify(() => mockBloc.add(CheckGrammarEvent(englishText: 'Test sentence'))).called(1);
  });

  testWidgets('displays loading spinner when GrammarLoading state', (tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([GrammarLoading()]),
      initialState: WrittingInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(const CheckGrammarPage()));
    await tester.pumpAndSettle();

    expect(find.byType(SpinKitDoubleBounce), findsOneWidget);
  });

  testWidgets('displays grammar result when GrammarLoaded state', (tester) async {
    final fakeGrammarResult = GrammarResult(
      correctedText: 'Corrected sentence',
      corrections: [
        Correction(
          originalPhrase: 'wrng',
          correctedPhrase: 'wrong',
          explanation: Explanation(english: 'Fixed typo', amharic: 'ትክክል ቃል'),
        ),
      ],
    );

    whenListen(
      mockBloc,
      Stream.fromIterable([GrammarLoaded(grammarResult: fakeGrammarResult)]),
      initialState: WrittingInitial(),
    );

    await tester.pumpWidget(makeTestableWidget(const CheckGrammarPage()));
    await tester.pumpAndSettle();

    expect(find.text('Corrected sentence'), findsOneWidget);
    expect(find.text('wrng'), findsOneWidget);
    expect(find.text('wrong'), findsOneWidget);
    expect(find.text('Fixed typo'), findsOneWidget);
  });

  testWidgets('clipboard paste and clear buttons work', (tester) async {
    when(() => mockBloc.state).thenReturn(WrittingInitial());

    await tester.pumpWidget(makeTestableWidget(const CheckGrammarPage()));
    await tester.pump();

    // Mock clipboard data
    await Clipboard.setData(const ClipboardData(text: 'Clipboard text'));

    // Tap paste button
    final pasteButton = find.byIcon(Icons.paste);
    await tester.tap(pasteButton);
    await tester.pump();

    expect(find.text('Clipboard text'), findsOneWidget);

    // Tap clear button
    final clearButton = find.byIcon(Icons.clear);
    await tester.tap(clearButton);
    await tester.pump();

    expect(find.text('Clipboard text'), findsNothing);
  });
}
