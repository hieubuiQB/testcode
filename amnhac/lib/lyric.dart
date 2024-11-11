// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
// import 'package:audioplayers/audioplayers.dart';
// import 'dart:async';
//
// class LyricsScreen extends StatefulWidget {
//   const LyricsScreen({Key? key}) : super(key: key);
//
//   @override
//   _LyricsScreenState createState() => _LyricsScreenState();
// }
//
// class _LyricsScreenState extends State<LyricsScreen> {
//   List<String> _lyrics = [];
//   List<double> _timestamps = [];
//   bool _isLoading = true;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   int _currentLyricIndex = 0;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLyrics();
//   }
//
//   Future<void> _fetchLyrics() async {
//     try {
//       // Tải lời bài hát và timestamps từ tệp JSON
//       final String response = await rootBundle.loadString('lib/a1/lyric.json');
//       final Map<String, dynamic> data = jsonDecode(response);
//
//       setState(() {
//         if (data['lyrics'] != null && data['lyrics'] is List) {
//           _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
//           _timestamps = data['timestamps'] != null && data['timestamps'] is List
//               ? List<double>.from(data['timestamps'].map((time) => time.toDouble()))
//               : [];
//         } else {
//           _lyrics = ['Không có lời bài hát'];
//           _timestamps = [];
//         }
//         _isLoading = false;
//       });
//
//       // Sau khi tải lời bài hát, phát nhạc
//       _playAudio();
//     } catch (e) {
//       setState(() {
//         _lyrics = ['Lỗi khi tải lời bài hát'];
//         _timestamps = [];
//         _isLoading = false;
//       });
//       print('Error loading lyrics: $e');
//     }
//   }
//
//   // Phát nhạc từ URL và cập nhật thời gian lời bài hát
//   Future<void> _playAudio() async {
//     // Thay URL bằng đường dẫn đến file nhạc của bạn
//     await _audioPlayer.play(UrlSource('https://storage.googleapis.com/ikara-storage/tmp/beat.mp3'));
//
//     // Sử dụng Timer để cập nhật lời bài hát mỗi 100ms
//     _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
//       Duration? position = await _audioPlayer.getCurrentPosition();
//       if (position != null) {
//         _updateCurrentLyric(position);
//       }
//     });
//   }
//
//   // Cập nhật chỉ số lời bài hát dựa trên thời gian phát nhạc
//   void _updateCurrentLyric(Duration duration) {
//     double currentTime = duration.inSeconds.toDouble() + duration.inMilliseconds.remainder(1000) / 1000.0;
//
//     // Cập nhật chỉ số dựa trên thời gian thực của bài nhạc
//     for (int i = 0; i < _timestamps.length - 1; i++) {
//       if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
//         if (_currentLyricIndex != i) {
//           setState(() {
//             _currentLyricIndex = i;
//           });
//         }
//         break;
//       }
//     }
//
//     // Nếu thời gian hiện tại vượt quá timestamp cuối cùng
//     if (currentTime >= _timestamps.last) {
//       setState(() {
//         _currentLyricIndex = _timestamps.length - 1;
//       });
//     }
//   }
//
//   // Nhảy đến vị trí phát nhạc tương ứng khi nhấn vào dòng lời bài hát
//   void _seekToLyric(int index) async {
//     if (index >= 0 && index < _timestamps.length) {
//       double targetTime = _timestamps[index];
//       await _audioPlayer.seek(Duration(seconds: targetTime.toInt(), milliseconds: ((targetTime % 1) * 1000).toInt()));
//
//       setState(() {
//         _currentLyricIndex = index;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Lời Bài Hát', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : _lyrics.isEmpty
//           ? const Center(
//         child: Text(
//           'Không tìm thấy lời bài hát.',
//           style: TextStyle(color: Colors.white, fontSize: 18.0),
//         ),
//       )
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: _lyrics.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () => _seekToLyric(index),  // Khi nhấn vào dòng lời bài hát
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         color: Colors.white.withOpacity(0.2),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                   child: Text(
//                     _lyrics[index],
//                     style: TextStyle(
//                       color: index == _currentLyricIndex ? Colors.yellow : Colors.white,
//                       fontSize: 20.0,
//                       fontWeight: index == _currentLyricIndex ? FontWeight.bold : FontWeight.normal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel(); // Dừng timer khi không còn cần thiết
//     _audioPlayer.dispose(); // Giải phóng tài nguyên của audio player
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
// import 'package:audioplayers/audioplayers.dart';
// import 'dart:async';
//
// class LyricsScreen extends StatefulWidget {
//   const LyricsScreen({Key? key}) : super(key: key);
//
//   @override
//   _LyricsScreenState createState() => _LyricsScreenState();
// }
//
// class _LyricsScreenState extends State<LyricsScreen> {
//   List<String> _lyrics = [];
//   List<double> _timestamps = [];
//   bool _isLoading = true;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   int _currentLyricIndex = 0;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLyrics();
//   }
//
//   Future<void> _fetchLyrics() async {
//     try {
//       // Tải lời bài hát và timestamps từ tệp JSON
//       final String response = await rootBundle.loadString('lib/a1/lyric.json');
//       final Map<String, dynamic> data = jsonDecode(response);
//
//       setState(() {
//         if (data['lyrics'] != null && data['lyrics'] is List) {
//           _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
//           _timestamps = data['timestamps'] != null && data['timestamps'] is List
//               ? List<double>.from(data['timestamps'].map((time) => time.toDouble()))
//               : [];
//         } else {
//           _lyrics = ['Không có lời bài hát'];
//           _timestamps = [];
//         }
//         _isLoading = false;
//       });
//
//       // Sau khi tải lời bài hát, phát nhạc
//       _playAudio();
//     } catch (e) {
//       setState(() {
//         _lyrics = ['Lỗi khi tải lời bài hát'];
//         _timestamps = [];
//         _isLoading = false;
//       });
//       print('Error loading lyrics: $e');
//     }
//   }
//
//   // Phát nhạc từ URL và cập nhật thời gian lời bài hát
//   Future<void> _playAudio() async {
//     // Thay URL bằng đường dẫn đến file nhạc của bạn
//     await _audioPlayer.play(UrlSource('https://storage.googleapis.com/ikara-storage/tmp/beat.mp3'));
//
//     // Sử dụng Timer để cập nhật lời bài hát mỗi 100ms
//     _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
//       Duration? position = await _audioPlayer.getCurrentPosition();
//       if (position != null) {
//         _updateCurrentLyric(position);
//       }
//     });
//   }
//
//   // Cập nhật chỉ số lời bài hát dựa trên thời gian phát nhạc
//   void _updateCurrentLyric(Duration duration) {
//     double currentTime = duration.inSeconds.toDouble() + duration.inMilliseconds.remainder(1000) / 1000.0;
//
//     // Cập nhật chỉ số dựa trên thời gian thực của bài nhạc
//     for (int i = 0; i < _timestamps.length - 1; i++) {
//       if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
//         if (_currentLyricIndex != i) {
//           setState(() {
//             _currentLyricIndex = i;
//           });
//         }
//         break;
//       }
//     }
//
//     // Nếu thời gian hiện tại vượt quá timestamp cuối cùng
//     if (currentTime >= _timestamps.last) {
//       setState(() {
//         _currentLyricIndex = _timestamps.length - 1;
//       });
//     }
//   }
//
//   // Nhảy đến vị trí phát nhạc tương ứng khi nhấn vào dòng lời bài hát
//   void _seekToLyric(int index) async {
//     if (index >= 0 && index < _timestamps.length) {
//       double targetTime = _timestamps[index];
//       await _audioPlayer.seek(Duration(seconds: targetTime.toInt(), milliseconds: ((targetTime % 1) * 1000).toInt()));
//
//       setState(() {
//         _currentLyricIndex = index;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Lời Bài Hát', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : _lyrics.isEmpty
//           ? const Center(
//         child: Text(
//           'Không tìm thấy lời bài hát.',
//           style: TextStyle(color: Colors.white, fontSize: 18.0),
//         ),
//       )
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: _lyrics.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () => _seekToLyric(index),  // Khi nhấn vào dòng lời bài hát
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         color: Colors.white.withOpacity(0.2),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                   child: Text(
//                     _lyrics[index],
//                     style: TextStyle(
//                       color: index == _currentLyricIndex ? Colors.yellow : Colors.white,
//                       fontSize: 20.0,
//                       fontWeight: index == _currentLyricIndex ? FontWeight.bold : FontWeight.normal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel(); // Dừng timer khi không còn cần thiết
//     _audioPlayer.dispose(); // Giải phóng tài nguyên của audio player
//     super.dispose();
//   }
// }

// code nay la chay loi bai hat
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
// import 'package:just_audio/just_audio.dart';
//
// class LyricsScreen extends StatefulWidget {
//   final AudioPlayer audioPlayer;
//   const LyricsScreen({Key? key, required this.audioPlayer}) : super(key: key);
//
//   @override
//   _LyricsScreenState createState() => _LyricsScreenState();
// }
//
// class _LyricsScreenState extends State<LyricsScreen> {
//   List<String> _lyrics = [];
//   List<double> _timestamps = [];
//   bool _isLoading = true;
//   int _currentLyricIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLyrics();
//     // Lắng nghe sự thay đổi vị trí phát nhạc để cập nhật lời bài hát
//     widget.audioPlayer.positionStream.listen((position) {
//       _updateCurrentLyric(position);
//     });
//   }
//
//   Future<void> _fetchLyrics() async {
//     try {
//       final String response = await rootBundle.loadString('lib/a1/lyric.json');
//       final Map<String, dynamic> data = jsonDecode(response);
//
//       setState(() {
//         _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
//         _timestamps = data['timestamps'] != null && data['timestamps'] is List
//             ? List<double>.from(data['timestamps'].map((time) => time.toDouble()))
//             : [];
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _lyrics = ['Lỗi khi tải lời bài hát'];
//         _timestamps = [];
//         _isLoading = false;
//       });
//       print('Error loading lyrics: $e');
//     }
//   }
//
//   void _updateCurrentLyric(Duration position) {
//     double currentTime = position.inSeconds.toDouble() + position.inMilliseconds.remainder(1000) / 1000.0;
//
//     for (int i = 0; i < _timestamps.length - 1; i++) {
//       if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
//         if (_currentLyricIndex != i) {
//           setState(() {
//             _currentLyricIndex = i;
//           });
//         }
//         break;
//       }
//     }
//
//     // Nếu thời gian hiện tại vượt quá timestamp cuối cùng
//     if (currentTime >= _timestamps.last) {
//       setState(() {
//         _currentLyricIndex = _timestamps.length - 1;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Lời Bài Hát', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: _lyrics.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4.0),
//               child: Text(
//                 _lyrics[index],
//                 style: TextStyle(
//                   color: index == _currentLyricIndex ? Colors.yellow : Colors.white,
//                   fontSize: 20.0,
//                   fontWeight: index == _currentLyricIndex ? FontWeight.bold : FontWeight.normal,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// code co chuc nang Chạy lời (lyrics) tô màu tới từng kí tự
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
// import 'package:just_audio/just_audio.dart';
//
// class LyricsScreen extends StatefulWidget {
//   final AudioPlayer audioPlayer;
//   const LyricsScreen({Key? key, required this.audioPlayer}) : super(key: key);
//
//   @override
//   _LyricsScreenState createState() => _LyricsScreenState();
// }
//
// class _LyricsScreenState extends State<LyricsScreen> {
//   List<String> _lyrics = [];
//   List<double> _timestamps = [];
//   bool _isLoading = true;
//   int _currentLyricIndex = 0;
//   int _currentCharIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLyrics();
//     // Lắng nghe sự thay đổi vị trí phát nhạc để cập nhật lời bài hát
//     widget.audioPlayer.positionStream.listen((position) {
//       _updateCurrentLyric(position);
//     });
//   }
//
//   Future<void> _fetchLyrics() async {
//     try {
//       final String response = await rootBundle.loadString('lib/a1/lyric.json');
//       final Map<String, dynamic> data = jsonDecode(response);
//
//       setState(() {
//         _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
//         _timestamps = data['timestamps'] != null && data['timestamps'] is List
//             ? List<double>.from(data['timestamps'].map((time) => time.toDouble()))
//             : [];
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _lyrics = ['Lỗi khi tải lời bài hát'];
//         _timestamps = [];
//         _isLoading = false;
//       });
//       print('Error loading lyrics: $e');
//     }
//   }
//
//   void _updateCurrentLyric(Duration position) {
//     double currentTime = position.inSeconds.toDouble() + position.inMilliseconds.remainder(1000) / 1000.0;
//
//     for (int i = 0; i < _timestamps.length - 1; i++) {
//       if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
//         if (_currentLyricIndex != i) {
//           setState(() {
//             _currentLyricIndex = i;
//             _currentCharIndex = 0;  // Reset ký tự khi chuyển sang dòng mới
//           });
//         }
//         break;
//       }
//     }
//
//     // Nếu thời gian hiện tại vượt quá timestamp cuối cùng
//     if (currentTime >= _timestamps.last) {
//       setState(() {
//         _currentLyricIndex = _timestamps.length - 1;
//       });
//     }
//
//     // Cập nhật chỉ số ký tự hiện tại
//     _updateCurrentCharIndex(currentTime);
//   }
//
//   void _updateCurrentCharIndex(double currentTime) {
//     String currentLyric = _lyrics[_currentLyricIndex];
//     double startTime = _timestamps[_currentLyricIndex];
//     double endTime = _timestamps.length > _currentLyricIndex + 1
//         ? _timestamps[_currentLyricIndex + 1]
//         : currentTime;
//
//     double duration = endTime - startTime;
//
//     // Chia thời gian cho số ký tự để xác định tốc độ tô màu
//     double timePerChar = duration / currentLyric.length;
//     int newCharIndex = ((currentTime - startTime) / timePerChar).floor();
//
//     if (newCharIndex != _currentCharIndex) {
//       setState(() {
//         _currentCharIndex = newCharIndex;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Lời Bài Hát', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: _lyrics.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: _buildLyricCharacters(_lyrics[index], index),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildLyricCharacters(String lyric, int index) {
//     List<Widget> characters = [];
//
//     for (int i = 0; i < lyric.length; i++) {
//       characters.add(
//         Text(
//           lyric[i],
//           style: TextStyle(
//             color: (index == _currentLyricIndex && i <= _currentCharIndex)
//                 ? Colors.yellow
//                 : Colors.white,
//             fontSize: 20.0,
//             fontWeight: (index == _currentLyricIndex && i <= _currentCharIndex)
//                 ? FontWeight.bold
//                 : FontWeight.normal,
//           ),
//         ),
//       );
//     }
//
//     return characters;
//   }
// }

// code chay ki tu bai hat
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
// import 'package:just_audio/just_audio.dart';
//
// class LyricsScreen extends StatefulWidget {
//   final AudioPlayer audioPlayer;
//   const LyricsScreen({Key? key, required this.audioPlayer}) : super(key: key);
//
//   @override
//   _LyricsScreenState createState() => _LyricsScreenState();
// }
//
// class _LyricsScreenState extends State<LyricsScreen> {
//   List<String> _lyrics = [];
//   List<double> _timestamps = [];
//   bool _isLoading = true;
//   int _currentLyricIndex = 0;
//   int _currentCharIndex = 0;
//   double _currentCharProgress = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLyrics();
//     // Lắng nghe sự thay đổi vị trí phát nhạc để cập nhật lời bài hát
//     widget.audioPlayer.positionStream.listen((position) {
//       _updateCurrentLyric(position);
//     });
//   }
//
//   Future<void> _fetchLyrics() async {
//     try {
//       final String response = await rootBundle.loadString('lib/a1/lyric.json');
//       final Map<String, dynamic> data = jsonDecode(response);
//
//       setState(() {
//         _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
//         _timestamps = data['timestamps'] != null && data['timestamps'] is List
//             ? List<double>.from(data['timestamps'].map((time) => time.toDouble()))
//             : [];
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _lyrics = ['Lỗi khi tải lời bài hát'];
//         _timestamps = [];
//         _isLoading = false;
//       });
//       print('Error loading lyrics: $e');
//     }
//   }
//
//   void _updateCurrentLyric(Duration position) {
//     double currentTime = position.inSeconds.toDouble() + position.inMilliseconds.remainder(1000) / 1000.0;
//
//     for (int i = 0; i < _timestamps.length - 1; i++) {
//       if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
//         if (_currentLyricIndex != i) {
//           setState(() {
//             _currentLyricIndex = i;
//             _currentCharIndex = 0;  // Reset ký tự khi chuyển sang dòng mới
//           });
//         }
//         break;
//       }
//     }
//
//     // Nếu thời gian hiện tại vượt quá timestamp cuối cùng
//     if (currentTime >= _timestamps.last) {
//       setState(() {
//         _currentLyricIndex = _timestamps.length - 1;
//       });
//     }
//
//     // Cập nhật chỉ số ký tự hiện tại và mức độ tô màu cho từng ký tự
//     _updateCurrentCharIndex(currentTime);
//   }
//
//   void _updateCurrentCharIndex(double currentTime) {
//     String currentLyric = _lyrics[_currentLyricIndex];
//     double startTime = _timestamps[_currentLyricIndex];
//     double endTime = _timestamps.length > _currentLyricIndex + 1
//         ? _timestamps[_currentLyricIndex + 1]
//         : currentTime;
//
//     double duration = endTime - startTime;
//
//     // Chia thời gian cho số ký tự để xác định tốc độ tô màu
//     double timePerChar = duration / currentLyric.length;
//     int newCharIndex = ((currentTime - startTime) / timePerChar).floor();
//
//     double progress = ((currentTime - startTime) % timePerChar) / timePerChar;
//
//     if (newCharIndex != _currentCharIndex || progress != _currentCharProgress) {
//       setState(() {
//         _currentCharIndex = newCharIndex;
//         _currentCharProgress = progress;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Lời Bài Hát', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: _lyrics.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: _buildLyricCharacters(_lyrics[index], index),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildLyricCharacters(String lyric, int index) {
//     List<Widget> characters = [];
//
//     for (int i = 0; i < lyric.length; i++) {
//       if (index == _currentLyricIndex && i == _currentCharIndex) {
//         characters.add(
//           Stack(
//             children: [
//               Text(
//                 lyric[i],
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.0,
//                 ),
//               ),
//               ShaderMask(
//                 shaderCallback: (bounds) {
//                   return LinearGradient(
//                     colors: [Colors.yellow, Colors.transparent],
//                     stops: [_currentCharProgress, _currentCharProgress],
//                   ).createShader(bounds);
//                 },
//                 blendMode: BlendMode.srcATop,
//                 child: Text(
//                   lyric[i],
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       } else {
//         characters.add(
//           Text(
//             lyric[i],
//             style: TextStyle(
//               color: (index == _currentLyricIndex && i < _currentCharIndex)
//                   ? Colors.yellow
//                   : Colors.white,
//               fontSize: 20.0,
//               fontWeight: (index == _currentLyricIndex && i <= _currentCharIndex)
//                   ? FontWeight.bold
//                   : FontWeight.normal,
//             ),
//           ),
//         );
//       }
//     }
//
//     return characters;
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';

class LyricsScreen extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const LyricsScreen({Key? key, required this.audioPlayer}) : super(key: key);

  @override
  _LyricsScreenState createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  List<String> _lyrics = [];
  List<double> _timestamps = [];
  bool _isLoading = true;
  int _currentLyricIndex = 0;
  int _currentCharIndex = 0;
  double _currentCharProgress = 0.0;
  bool _showDots = true; // Thêm biến để kiểm soát hiển thị dấu chấm
  final double _introSkipTime = 20.0; // Ví dụ: bỏ qua phần dạo đầu 5 giây

  @override
  void initState() {
    super.initState();
    _fetchLyrics();
    // Lắng nghe sự thay đổi vị trí phát nhạc để cập nhật lời bài hát
    widget.audioPlayer.positionStream.listen((position) {
      _updateCurrentLyric(position);
    });
  }

  Future<void> _fetchLyrics() async {
    try {
      final String response = await rootBundle.loadString('lib/a1/lyric.json');
      final Map<String, dynamic> data = jsonDecode(response);

      setState(() {
        _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
        _timestamps = data['timestamps'] != null && data['timestamps'] is List
            ? List<double>.from(data['timestamps'].map((time) => time.toDouble()))
            : [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lyrics = ['Lỗi khi tải lời bài hát'];
        _timestamps = [];
        _isLoading = false;
      });
      print('Error loading lyrics: $e');
    }
  }

  void _updateCurrentLyric(Duration position) {
    double currentTime = position.inSeconds.toDouble() + position.inMilliseconds.remainder(1000) / 1000.0;

    if (currentTime < _introSkipTime) {
      setState(() {
        _showDots = true; // Hiển thị dấu chấm trong phần dạo đầu
      });
    } else {
      setState(() {
        _showDots = false; // Ẩn dấu chấm khi đến phần chính của bài hát
      });
      for (int i = 0; i < _timestamps.length - 1; i++) {
        if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
          if (_currentLyricIndex != i) {
            setState(() {
              _currentLyricIndex = i;
              _currentCharIndex = 0;  // Reset ký tự khi chuyển sang dòng mới
            });
          }
          break;
        }
      }

      // Nếu thời gian hiện tại vượt quá timestamp cuối cùng
      if (currentTime >= _timestamps.last) {
        setState(() {
          _currentLyricIndex = _timestamps.length - 1;
        });
      }

      // Cập nhật chỉ số ký tự hiện tại và mức độ tô màu cho từng ký tự
      _updateCurrentCharIndex(currentTime);
    }
  }

  void _updateCurrentCharIndex(double currentTime) {
    String currentLyric = _lyrics[_currentLyricIndex];
    double startTime = _timestamps[_currentLyricIndex];
    double endTime = _timestamps.length > _currentLyricIndex + 1
        ? _timestamps[_currentLyricIndex + 1]
        : currentTime;

    double duration = endTime - startTime;

    // Chia thời gian cho số ký tự để xác định tốc độ tô màu
    double timePerChar = duration / currentLyric.length;
    int newCharIndex = ((currentTime - startTime) / timePerChar).floor();

    double progress = ((currentTime - startTime) % timePerChar) / timePerChar;

    if (newCharIndex != _currentCharIndex || progress != _currentCharProgress) {
      setState(() {
        _currentCharIndex = newCharIndex;
        _currentCharProgress = progress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Lời Bài Hát', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_showDots) ...[
              // Hiển thị 3 dấu chấm khi nhạc đang ở phần dạo đầu
              const Text(
                "...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: _lyrics.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildLyricCharacters(_lyrics[index], index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tạo danh sách từng ký tự và tô màu mượt mà
  List<Widget> _buildLyricCharacters(String lyric, int index) {
    List<Widget> characters = [];

    for (int i = 0; i < lyric.length; i++) {
      if (index == _currentLyricIndex && i == _currentCharIndex) {
        characters.add(
          Stack(
            children: [
              Text(
                lyric[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Colors.yellow, Colors.transparent],
                    stops: [_currentCharProgress, _currentCharProgress],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: Text(
                  lyric[i],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        characters.add(
          Text(
            lyric[i],
            style: TextStyle(
              color: (index == _currentLyricIndex && i < _currentCharIndex)
                  ? Colors.yellow
                  : Colors.white,
              fontSize: 20.0,
              fontWeight: (index == _currentLyricIndex && i <= _currentCharIndex)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }
    }

    return characters;
  }
}
