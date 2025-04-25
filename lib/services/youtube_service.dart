import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeService {
  static const String _apiKey = ''; // Get a Key from Google (or YouTube if they separate-out from Google) and add it in the single quotes.
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  Future<List<dynamic>> getTrendingMusic() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/videos?part=snippet&chart=mostPopular&videoCategoryId=10&maxResults=10&key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['items'] ?? [];
      } else {
        print('YouTube API Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching trending music: $e');
      return [];
    }
  }
} 