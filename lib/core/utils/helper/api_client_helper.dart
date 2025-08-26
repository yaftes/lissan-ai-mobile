import 'package:http/http.dart' as http;

class ApiClientHelper {
  final http.Client client;
  Map<String, String> get _headers => {'Content-Type': 'Application/json'};
  ApiClientHelper({required this.client});

  Future<http.Response> get(String url) {
    return client.get(headers: _headers, Uri.parse(url));
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) {
    return client.post(headers: _headers, body: body, Uri.parse(url));
  }

  Future<http.Response> put(String url, Map<String, dynamic> body){
    return client.put(headers: _headers, body: body, Uri.parse(url));
  }

  Future<http.Response> delete(String url){
    return client.delete(Uri.parse(url));
  }
}
