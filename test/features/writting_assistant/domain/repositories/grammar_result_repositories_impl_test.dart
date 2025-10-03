import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/writting_assistant/domain/entities/grammar_result.dart';
import 'package:lissan_ai/features/writting_assistant/domain/repositories/grammar_repository.dart';

class MockGrammarRepository extends Mock implements GrammarRepository {}

void main() {
  late MockGrammarRepository mockRepository;

  setUp(() {
    mockRepository = MockGrammarRepository();
  });

  const tEnglishText = 'helo world';
  final tGrammarResult = GrammarResult(correctedText: 'hello world', corrections: []);

  test('should return Right(GrammarResult) when repository succeeds', () async {
    // arrange
    when(() => mockRepository.checkGrammar(any()))
        .thenAnswer((_) async => Right(tGrammarResult));

    // act
    final result = await mockRepository.checkGrammar(tEnglishText);

    // assert
    expect(result, Right(tGrammarResult));
    verify(() => mockRepository.checkGrammar(tEnglishText)).called(1);
  });

  test('should return Left(Failure) when repository fails', () async {
    // arrange
    final tFailure = const ServerFailure(message: 'Server error');
    when(() => mockRepository.checkGrammar(any()))
        .thenAnswer((_) async => Left(tFailure));

    // act
    final result = await mockRepository.checkGrammar(tEnglishText);

    // assert
    expect(result, Left(tFailure));
    verify(() => mockRepository.checkGrammar(tEnglishText)).called(1);
  });
}
