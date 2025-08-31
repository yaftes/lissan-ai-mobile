import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClientHelper {
  final http.Client client;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization':'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjhhZjc0M2U2YThmYTNlM2Q1MjJiZGMwIiwic3ViIjoiNjhhZjc0M2U2YThmYTNlM2Q1MjJiZGMwIiwiZXhwIjoxNzU2OTM1MTIyLCJpYXQiOjE3NTYzMzAzMjJ9.SzzbDaP14S5FuHKeTrXQozVDANkKZrFfg0YvymH3FLA'
  };

  ApiClientHelper({required this.client});

  Future<http.Response> get(String url) {
    return client.get(Uri.parse(url), headers: _headers);
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) {
    return client.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode(body), // JSON encoding
    );
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) {
    return client.put(
      Uri.parse(url),
      headers: _headers,
      body: json.encode(body),
    );
  }

  Future<http.Response> delete(String url) {
    return client.delete(Uri.parse(url), headers: _headers);
  }
}
