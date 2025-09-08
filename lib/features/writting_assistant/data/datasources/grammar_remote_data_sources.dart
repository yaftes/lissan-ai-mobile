import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/core/utils/constants/auth_constants.dart';
import 'package:lissan_ai/core/utils/constants/writting_constant.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/grammar_result_model.dart';
import 'package:http/http.dart' as http;

abstract class GrammarRemoteDataSources {
  Future<GrammarResultModel> checkGrammar(String englishText);
}

class GrammarRemoteDataSourcesImpl implements GrammarRemoteDataSources {
  final http.Client client;
  final FlutterSecureStorage storage;

  GrammarRemoteDataSourcesImpl({required this.storage, required this.client});

  @override
  Future<GrammarResultModel> checkGrammar(String englishText) async {
    final token = await storage.read(key: AuthConstants.accessToken);

    if (token == null) {
      throw const ServerException(message: 'No access token found');
    }

    debugPrint('🔑 Access Token: $token');

    final url = Uri.parse(
      writting_constant.baseUrl + writting_constant.checkGrammarEndpoint,
    );

    debugPrint('🌍 Request URL: $url');
    debugPrint('📩 Request Body: ${jsonEncode({'text': englishText})}');

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'text': englishText}),
      );

      // Always log response for debugging
      debugPrint('📡 Response Status: ${response.statusCode}');
      debugPrint('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final result = GrammarResultModel.fromJson(decoded);

        debugPrint('✅ Corrected text: ${result.correctedText}');
        for (var correction in result.corrections) {
          debugPrint('🔹 Original: ${correction.originalPhrase}');
          debugPrint('🔹 Corrected: ${correction.correctedPhrase}');
          debugPrint(
            '🔹 English Explanation: ${correction.explanation.english}',
          );
          debugPrint(
            '🔹 Amharic Explanation: ${correction.explanation.amharic}',
          );
        }

        return result;
      } else {
        throw ServerException(
          message: 'Failed to check grammar. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error during grammar check: $e');
      throw ServerException(message: e.toString());
    }
  }
}
