import 'package:flutter/material.dart';
import 'package:record/record.dart';
import '../services/audd_service.dart';
import 'package:path_provider/path_provider.dart';

class IdentifyPage extends StatefulWidget {
  const IdentifyPage({super.key});

  @override
  _IdentifyPageState createState() => _IdentifyPageState();
}

class _IdentifyPageState extends State<IdentifyPage> {
  final AuddService _auddService = AuddService('15a032aef9e3652699236126ecf9866c');
  final _audioRecorder = AudioRecorder();
  String _result = '';
  bool _isRecording = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _recordAudio() async {
    if (_isRecording) {
      // Stop recording
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _result = 'Processing...';
      });

      if (path != null) {
        try {
          final result = await _auddService.recognizeSong(path);
          setState(() {
            _result = result['result']['title'] ?? 'No song recognized';
          });
        } catch (e) {
          setState(() {
            _result = 'Error: $e';
          });
        }
      }
    } else {
      // Start recording
      if (await _audioRecorder.hasPermission()) {
        // Get temporary directory
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/audio_record.m4a';
        
        // Start recording to file
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
          ),
          path: path,
        );
        setState(() {
          _isRecording = true;
          _result = 'Recording... Tap again to stop';
        });
      } else {
        setState(() {
          _result = 'Microphone permission denied';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Identify Song'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tap the button and play music',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              FloatingActionButton.large(
                onPressed: _recordAudio,
                elevation: _isRecording ? 8 : 4,
                backgroundColor: _isRecording 
                  ? Theme.of(context).colorScheme.errorContainer
                  : Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  size: 32,
                  color: _isRecording 
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _result,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 