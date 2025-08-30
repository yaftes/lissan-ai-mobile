import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/grammar_result_model.dart';
import 'package:http/http.dart' as http;

abstract class GrammarRemoteDataSources {
  Future<GrammarResultModel> checkGrammar(String englishText);
}

class GrammarRemoteDataSourcesimpl implements GrammarRemoteDataSources {
  final http.Client client;

  GrammarRemoteDataSourcesimpl({required this.client});
  @override
  Future<GrammarResultModel> checkGrammar(String englishText) async {
    final response = await client.post(
      Uri.parse(
        'https://lissan-ai-backend-dev.onrender.com/api/v1/grammar/check/',
      ),

      headers: {
        'Content-type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjhhOGUyMTk3NWQ1NDQ0MjAzOGYyMDk2Iiwic3ViIjoiNjhhOGUyMTk3NWQ1NDQ0MjAzOGYyMDk2IiwiZXhwIjoxNzU2OTA5NTg5LCJpYXQiOjE3NTYzMDQ3ODl9._sqDZPDK6Wf_nc3q5MDZLyVB3GZz8ag1_C1eHspMujQ',
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
