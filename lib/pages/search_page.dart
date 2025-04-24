import 'package:flutter/material.dart';
import '../services/youtube_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;
  final YouTubeService _youtubeService = YouTubeService('AIzaSyCSRme32xO618i-5iTIz0_XI4sos6gzNfI');
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Request focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _isKeyboardVisible = true;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _isKeyboardVisible = false;
                });
                if (value.isNotEmpty) {
                  _youtubeService.searchVideos(value).then((results) {
                    setState(() {
                      _searchResults = results;
                    });
                  }).catchError((error) {
                    // Handle any errors here
                    print('Error fetching videos: $error');
                  });
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final video = _searchResults[index];
                return ListTile(
                  title: Text(video['snippet']['title']),
                  subtitle: Text(video['snippet']['description']),
                  leading: Image.network(video['snippet']['thumbnails']['default']['url']),
                  onTap: () {
                    // Handle video tap (e.g., navigate to video player)
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class YouTubeService {
  final String apiKey;

  YouTubeService(this.apiKey);

  Future<List<dynamic>> searchVideos(String query) async {
    final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)['items'];
    } else {
      throw Exception('Failed to load videos: ${response.statusCode}');
    }
  }
} 