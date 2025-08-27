import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/result.dart';

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  const ApiClient({
    required this.baseUrl,
    this.defaultHeaders = const {'Accept': 'application/json'},
  });

  Future<Result<dynamic>> getJson(String path, {Map<String, String>? headers, Map<String, String>? query}) async {
    final uri = Uri.parse(baseUrl).replace(
      path: path.startsWith('/') ? path : '/$path',
      queryParameters: query,
    );
    try {
      final res = await http.get(uri, headers: {...defaultHeaders, ...?headers});
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Ok(json.decode(utf8.decode(res.bodyBytes)));
      }
      return Err('HTTP ${res.statusCode}: ${res.body}');
    } catch (e, st) {
      return Err(e, st);
    }
  }
}
