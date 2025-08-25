import 'dart:convert';
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
      Uri.parse('https://your-api.com/checkGrammar'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'english_text': englishText}),
    );

    if (response.statusCode == 200) {
      return GrammarResultModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to check grammar');
    }
  }
}
