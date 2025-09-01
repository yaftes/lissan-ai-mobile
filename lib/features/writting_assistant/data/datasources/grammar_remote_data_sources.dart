import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lissan_ai/core/utils/constants/auth_constants.dart';
import 'package:lissan_ai/core/utils/constants/writting_constant.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/grammar_result_model.dart';
import 'package:http/http.dart' as http;

abstract class GrammarRemoteDataSources {
  Future<GrammarResultModel> checkGrammar(String englishText);
}

class GrammarRemoteDataSourcesimpl implements GrammarRemoteDataSources {
  final http.Client client;
  final FlutterSecureStorage storage;

  GrammarRemoteDataSourcesimpl({
    required this.storage,
    required this.client});
  @override
  Future<GrammarResultModel> checkGrammar(String englishText) async {
    final response = await client.post(
      Uri.parse(
        writting_constant.baseUrl + writting_constant.checkGrammarEndpoint,
      ),

      headers: {
        'Content-type': 'application/json',
        'Authorization':
            'Bearer ${storage.read(key: AuthConstants.accessToken)}',
      },
      body: jsonEncode({'text': englishText}),
    );
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final result = GrammarResultModel.fromJson(jsonDecode(response.body));
      debugPrint('Parsed result: $result');
      return result;
    } else {
      throw Exception('Failed to check grammar');
    }
  }
}
