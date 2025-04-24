import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeService {
  // Replace this string with your actual YouTube Data API v3 key
  static const String _apiKey = 'AIzaSyCSRme32xO618i-5iTIz0_XI4sos6gzNfI'; // Your actual API key goes here
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