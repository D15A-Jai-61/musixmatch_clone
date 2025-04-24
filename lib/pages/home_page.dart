import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/youtube_service.dart';
import 'settings_page.dart';
import 'package:pip/pip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final YoutubeService _youtubeService = YoutubeService();
  bool _overlayPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkOverlayPermission();
  }

  Future<void> _checkOverlayPermission() async {
    final status = await Permission.systemAlertWindow.status;
    setState(() {
      _overlayPermissionGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: InkWell(
                onTap: () async {
                  final Uri url = Uri.parse('https://t.musixmatch.com/pro/distribute-lyrics-spotify-instagram');
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch URL')),
                    );
                  }
                },
                child: Column(
                  children: [
                    Image.asset('assets/DistributeYourLyrics.png'),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Distribute Your Lyrics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: InkWell(
                onTap: () async {
                  if (!_overlayPermissionGranted) {
                    final status = await Permission.systemAlertWindow.request();
                    setState(() {
                      _overlayPermissionGranted = status.isGranted;
                    });
                    if (!status.isGranted) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Permission required for floating lyrics')),
                        );
                      }
                      return;
                    }
                  }
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => const FloatingLyricsDialog(),
                    );
                  }
                },
                child: Column(
                  children: [
                    Image.asset('assets/FloatingLyrics.png'),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Floating Lyrics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Trending on YouTube',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<dynamic>>(
              future: _youtubeService.getTrendingMusic(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No trending videos available'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final video = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            video['snippet']['thumbnails']['default']['url'],
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          video['snippet']['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          video['snippet']['channelTitle'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onTap: () {
                          // TODO: Implement video playback
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingLyricsDialog extends StatefulWidget {
  const FloatingLyricsDialog({super.key});

  @override
  State<FloatingLyricsDialog> createState() => _FloatingLyricsDialogState();
}

class _FloatingLyricsDialogState extends State<FloatingLyricsDialog> {
  final _pip = Pip();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _setupPiP();
  }

  Future<void> _setupPiP() async {
    if (await _pip.isSupported()) {
      await _pip.setup(PipOptions(
        aspectRatioX: 16,
        aspectRatioY: 9,
        autoEnterEnabled: false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {},
                ),
                FilledButton.icon(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Pause' : 'Play'),
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () async {
                if (await _pip.isSupported()) {
                  await _pip.start();
                }
              },
              child: const Text('Enter PiP Mode'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pip.dispose();
    super.dispose();
  }
} 