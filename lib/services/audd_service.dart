import 'dart:convert';
import 'package:http/http.dart' as http;

class AuddService {
  final String apiKey;

  AuddService(this.apiKey);

  Future<Map<String, dynamic>> recognizeSong(String audioFilePath) async {
    final uri = Uri.parse('https://api.audd.io/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['api_token'] = apiKey
      ..files.add(await http.MultipartFile.fromPath('file', audioFilePath));

    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return json.decode(responseData.body);
    } else {
      throw Exception('Failed to recognize song: ${responseData.body}');
    }
  }
} 