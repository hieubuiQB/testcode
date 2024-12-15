import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';

import 'lyric.dart';

// Main Application
void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lyrics Sync Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MusicPlayerScreen(),
    );
  }
}

// Music Player Screen
class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setUrl('https://storage.googleapis.com/ikara-storage/tmp/beat.mp3');

    // Listen to audio duration
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    // Listen to audio position
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Music Player', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_snippet, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LyricsScreen(audioPlayer: _audioPlayer),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 250.0,
                height: 250.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/250'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 15.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: const [
                Text(
                  'Song Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Artist Name',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Slider(
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.grey,
            min: 0.0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
            onChanged: (value) {
              final position = Duration(seconds: value.toInt());
              _audioPlayer.seek(position);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LyricsScreen(
                    audioPlayer: _audioPlayer,
                  ),
                ),
              );
              setState(() {
                _position = position;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  _formatDuration(_duration),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                color: Colors.white,
                iconSize: 48.0,
                onPressed: () {},
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(_audioPlayer.playing ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
                iconSize: 64.0,
                onPressed: () {
                  if (_audioPlayer.playing) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play();
                  }
                  setState(() {});
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.skip_next),
                color: Colors.white,
                iconSize: 48.0,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}


