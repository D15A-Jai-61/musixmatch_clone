import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
  }

  Future<void> checkAndRequestPermissions() async {
    // For Android 13+ we need READ_MEDIA_AUDIO permission
    if (await Permission.audio.status.isDenied) {
      final status = await Permission.audio.request();
      setState(() {
        _hasPermission = status.isGranted;
      });
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return _buildPermissionRequest();
    }
    return _buildMusicLibrary();
  }

  Widget _buildPermissionRequest() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Library'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_note,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Music Library Access Required',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Please grant permission to access your device\'s music files',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: checkAndRequestPermissions,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Grant Access'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMusicLibrary() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Library'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Implement sorting options
            },
            tooltip: 'Sort songs',
          ),
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: SongSortType.TITLE,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          if (!snapshot.hasData) {
            return _buildLoadingState();
          }

          return _buildSongsList(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading music',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Music Found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Add some music to your device to see it here',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your music...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildSongsList(List<SongModel> songs) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            title: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              song.artist ?? 'Unknown Artist',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: Show song options menu
              },
            ),
            onTap: () {
              // TODO: Play the selected song
            },
          ),
        );
      },
    );
  }
} 