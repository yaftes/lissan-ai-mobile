import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/correction_model.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/explanation_model.dart';
import 'package:lissan_ai/features/writting_assistant/domain/entities/correction.dart';
import 'package:lissan_ai/features/writting_assistant/domain/entities/grammar_result.dart';

class FakeCorrection extends Correction {
  FakeCorrection({
    required super.originalPhrase,
    required super.correctedPhrase,
    required super.explanation,
  });
}

void main() {
  group('GrammarResult Entity', () {
    test('should store correctedText and corrections properly', () {
      // arrange
      final tExplanationModel = ExplanationModel(
        english: 'Wrong tense',
        amharic: 'የተሳሳተ ጊዜ',
      );

      final tCorrectionModel = CorrectionModel(
        originalPhrase: 'helo',
        correctedPhrase: 'hello',
        explanation: tExplanationModel,
      );

      final fakeCorrection = FakeCorrection(
        originalPhrase: tCorrectionModel.originalPhrase,
        correctedPhrase: tCorrectionModel.correctedPhrase,
        explanation: tCorrectionModel.explanation,
      );

      final grammarResult = GrammarResult(
        correctedText: 'hello world',
        corrections: [fakeCorrection],
      );

      // assert
      expect(grammarResult.correctedText, 'hello world');
      expect(grammarResult.corrections, isNotEmpty);
      expect(grammarResult.corrections.first.originalPhrase, 'helo');
      expect(grammarResult.corrections.first.correctedPhrase, 'hello');
      expect(grammarResult.corrections.first.explanation, isA<ExplanationModel>());
      expect((grammarResult.corrections.first.explanation as ExplanationModel).english,
          'Wrong tense');
      expect((grammarResult.corrections.first.explanation as ExplanationModel).amharic,
          'የተሳሳተ ጊዜ');
    });

    test('should handle empty corrections list', () {
      // arrange
      final grammarResult = GrammarResult(
        correctedText: 'fixed text',
        corrections: [],
      );

      // assert
      expect(grammarResult.correctedText, 'fixed text');
      expect(grammarResult.corrections, isEmpty);
    });
  });
}
