import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/grammar_result_model.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/correction_model.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/explanation_model.dart';

void main() {
  group('GrammarResultModel', () {
    final tExplanationModel = ExplanationModel(
      english: 'Wrong tense',
      amharic: 'የተሳሳተ ጊዜ',
    );

    final tCorrectionModel = CorrectionModel(
      originalPhrase: 'helo',
      correctedPhrase: 'hello',
      explanation: tExplanationModel,
    );

    final tGrammarResultModel = GrammarResultModel(
      correctedText: 'hello world',
      corrections: [tCorrectionModel],
    );

    test('fromJson should return valid model when JSON is correct', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'corrected_text': 'hello world',
        'corrections': [
          {
            'original_phrase': 'helo',
            'corrected_phrase': 'hello',
            'explanation': {
              'english': 'Wrong tense',
              'amharic': 'የተሳሳተ ጊዜ',
            }
          }
        ]
      };

      // act
      final result = GrammarResultModel.fromJson(jsonMap);

      // assert
      expect(result.correctedText, tGrammarResultModel.correctedText);
      expect(result.corrections.length, 1);
      expect(result.corrections.first.originalPhrase, 'helo');
      expect(result.corrections.first.correctedPhrase, 'hello');
      expect(result.corrections.first.explanation.english, 'Wrong tense');
      expect(result.corrections.first.explanation.amharic, 'የተሳሳተ ጊዜ');
    });

    test('fromJson should handle empty corrections list', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'corrected_text': 'fixed text',
        'corrections': [],
      };

      // act
      final result = GrammarResultModel.fromJson(jsonMap);

      // assert
      expect(result.correctedText, 'fixed text');
      expect(result.corrections, isEmpty);
    });

    test('fromJson should handle missing corrections key', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'corrected_text': 'fixed text',
      };

      // act
      final result = GrammarResultModel.fromJson(jsonMap);

      // assert
      expect(result.correctedText, 'fixed text');
      expect(result.corrections, isEmpty);
    });

    test('fromJson should handle null corrected_text', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'corrected_text': null,
        'corrections': [],
      };

      // act
      final result = GrammarResultModel.fromJson(jsonMap);

      // assert
      expect(result.correctedText, '');
      expect(result.corrections, isEmpty);
    });
  });
}
