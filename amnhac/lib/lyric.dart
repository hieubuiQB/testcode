//
// //cuon bai hat tu dong
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
//   final ScrollController _scrollController = ScrollController();
//   bool _showIntro = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLyrics();
//     widget.audioPlayer.positionStream.listen((position) {
//       _updateCurrentLyric(position);
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchLyrics() async {
//     try {
//       final String response = await rootBundle.loadString('lib/a1/lyric.json');
//       final Map<String, dynamic> data = jsonDecode(response);
//
//       setState(() {
//         _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
//         _timestamps = List<double>.from(data['timestamps'].map((time) => time.toDouble()));
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _lyrics = ['Error loading lyrics'];
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
//             _currentCharIndex = 0; // Reset ký tự khi chuyển sang dòng mới
//           });
//
//           // Cuộn đến dòng hiện tại
//           _scrollToCurrentLyric();
//         }
//         break;
//       }
//     }
//
//     // Nếu thời gian phát vượt qua dòng cuối
//     if (currentTime >= _timestamps.last) {
//       setState(() {
//         _currentLyricIndex = _timestamps.length - 1;
//       });
//
//       _scrollToCurrentLyric();
//     }
//
//     _updateCurrentCharIndex(currentTime);
//   }
//
//   void _scrollToCurrentLyric() {
//     if (_scrollController.hasClients) {
//       double targetPosition = _currentLyricIndex * 50.0; // Điều chỉnh chiều cao phù hợp
//       _scrollController.animateTo(
//         targetPosition - 100, // Dòng hiện tại ở gần giữa màn hình
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _updateCurrentCharIndex(double currentTime) {
//     if (_currentLyricIndex >= _lyrics.length) return;
//
//     String currentLyric = _lyrics[_currentLyricIndex];
//     double startTime = _timestamps[_currentLyricIndex];
//     double endTime = _timestamps.length > _currentLyricIndex + 1
//         ? _timestamps[_currentLyricIndex + 1]
//         : currentTime;
//
//     double duration = endTime - startTime;
//
//     // Tính thời gian cho mỗi ký tự
//     double timePerChar = duration / currentLyric.length;
//     int newCharIndex = ((currentTime - startTime) / timePerChar).floor();
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
//         title: const Text('Lyrics', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : ListView.builder(
//         controller: _scrollController, // Gắn ScrollController
//         itemCount: _lyrics.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: _buildLyricCharacters(_lyrics[index], index),
//             ),
//           );
//         },
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
//                 style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
//                   style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
//

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
//   bool _showIntro = true;
//   int _currentLyricIndex = 0;
//   int _currentCharIndex = 0;
//   double _currentCharProgress = 0.0;
//   double _introEnd = 0.0;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLyrics();
//     widget.audioPlayer.positionStream.listen((position) {
//       _updateCurrentLyric(position);
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchLyrics() async {
//     try {
//       final String response = await rootBundle.loadString('lib/a1/lyric.json');
//       final Map<String, dynamic> data = jsonDecode(response);
//
//       setState(() {
//         _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
//         _timestamps = List<double>.from(data['timestamps'].map((time) => time.toDouble()));
//         _introEnd = data['introEnd'];
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _lyrics = ['Error loading lyrics'];
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
//     // Kiểm tra xem khúc dạo đầu có kết thúc chưa
//     if (_showIntro && currentTime >= _introEnd) {
//       setState(() {
//         _showIntro = false; // Kết thúc dạo đầu
//       });
//     }
//
//     // Xử lý cập nhật lời bài hát sau dạo đầu
//     if (!_showIntro) {
//       for (int i = 0; i < _timestamps.length - 1; i++) {
//         if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
//           if (_currentLyricIndex != i) {
//             setState(() {
//               _currentLyricIndex = i;
//               _currentCharIndex = 0;
//             });
//
//             _scrollToCurrentLyric();
//           }
//           break;
//         }
//       }
//
//       if (currentTime >= _timestamps.last) {
//         setState(() {
//           _currentLyricIndex = _timestamps.length - 1;
//         });
//
//         _scrollToCurrentLyric();
//       }
//
//       _updateCurrentCharIndex(currentTime);
//     }
//   }
//
//   void _scrollToCurrentLyric() {
//     if (_scrollController.hasClients) {
//       double targetPosition = _currentLyricIndex * 50.0; // Điều chỉnh chiều cao phù hợp
//       _scrollController.animateTo(
//         targetPosition - 100, // Dòng hiện tại ở gần giữa màn hình
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   // void _updateCurrentCharIndex(double currentTime) {
//   //   if (_currentLyricIndex >= _lyrics.length) return;
//   //
//   //   String currentLyric = _lyrics[_currentLyricIndex];
//   //   double startTime = _timestamps[_currentLyricIndex];
//   //   double endTime = _timestamps.length > _currentLyricIndex + 1
//   //       ? _timestamps[_currentLyricIndex + 1]
//   //       : currentTime;
//   //
//   //   double duration = endTime - startTime;
//   //
//   //   // Hiệu chỉnh một khoảng trễ nhỏ để đồng bộ
//   //   const double syncOffset = 0.1; // Thời gian trễ 0.1 giây (có thể điều chỉnh)
//   //   double adjustedStartTime = startTime + syncOffset;
//   //
//   //   if (currentTime < adjustedStartTime) {
//   //     setState(() {
//   //       _currentCharIndex = 0;
//   //       _currentCharProgress = 0.0;
//   //     });
//   //     return;
//   //   }
//   //
//   //   double elapsedTime = currentTime - adjustedStartTime;
//   //   double timePerChar = duration / currentLyric.length;
//   //   int newCharIndex = (elapsedTime / timePerChar).floor();
//   //   double progress = (elapsedTime % timePerChar) / timePerChar;
//   //
//   //   if (newCharIndex != _currentCharIndex || progress != _currentCharProgress) {
//   //     setState(() {
//   //       _currentCharIndex = newCharIndex.clamp(0, currentLyric.length - 1);
//   //       _currentCharProgress = progress;
//   //     });
//   //   }
//   // }
//
//   void _updateCurrentCharIndex(double currentTime) {
//     if (_currentLyricIndex >= _lyrics.length) return;
//
//     String currentLyric = _lyrics[_currentLyricIndex];
//     double startTime = _timestamps[_currentLyricIndex];
//     double endTime = _timestamps.length > _currentLyricIndex + 1
//         ? _timestamps[_currentLyricIndex + 1]
//         : currentTime;
//
//     // Thời lượng phát đoạn lời hiện tại
//     double duration = endTime - startTime;
//
//     // Nếu chưa đến thời gian hiển thị câu này
//     if (currentTime < startTime) {
//       setState(() {
//         _currentCharIndex = 0;
//         _currentCharProgress = 0.0;
//       });
//       return;
//     }
//
//     // Thời gian đã trôi qua trong câu hiện tại
//     double elapsedTime = currentTime - startTime;
//
//     // Tính thời gian cho mỗi ký tự
//     double timePerChar = duration / currentLyric.length;
//     int newCharIndex = (elapsedTime / timePerChar).floor();
//     double progress = (elapsedTime % timePerChar) / timePerChar;
//
//     // Cập nhật trạng thái hiển thị ký tự
//     if (newCharIndex != _currentCharIndex || progress != _currentCharProgress) {
//       setState(() {
//         _currentCharIndex = newCharIndex.clamp(0, currentLyric.length - 1);
//         _currentCharProgress = progress;
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Lyrics', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : _showIntro
//           ? Center(
//         child: Text(
//           '...',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 60.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       )
//           : ListView.builder(
//         controller: _scrollController,
//         itemCount: _lyrics.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: _buildLyricCharacters(_lyrics[index], index),
//             ),
//           );
//         },
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
//                 style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
//                   style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
//   bool _showIntro = true;
//   int _currentLyricIndex = 0;
//   int _currentCharIndex = 0;
//   double _currentCharProgress = 0.0;
//   double _introEnd = 0.0;
//   double _timeOffset = 0.0; // Offset để điều chỉnh độ khớp thời gian
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLyrics();
//     widget.audioPlayer.positionStream.listen((position) {
//       _updateCurrentLyric(position);
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchLyrics() async {
//     try {
//       final String response = await rootBundle.loadString('lib/a1/lyric.json');
//       final Map<String, dynamic> data = jsonDecode(response);
//
//       setState(() {
//         _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
//         _timestamps = List<double>.from(data['timestamps'].map((time) => time.toDouble()));
//         _introEnd = data['introEnd'];
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _lyrics = ['Error loading lyrics'];
//         _timestamps = [];
//         _isLoading = false;
//       });
//       print('Error loading lyrics: $e');
//     }
//   }
//   void _seekLyrics(Duration position) {
//     double currentTime = position.inSeconds.toDouble() +
//         position.inMilliseconds.remainder(1000) / 1000.0 +
//         _timeOffset;
//
//     // Xác định câu hiện tại dựa vào _timestamps
//     for (int i = 0; i < _timestamps.length - 1; i++) {
//       if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
//         setState(() {
//           _currentLyricIndex = i;
//           _currentCharIndex = 0; // Reset ký tự
//         });
//         _scrollToCurrentLyric(); // Scroll tới vị trí lời bài hát hiện tại
//         break;
//       }
//     }
//
//     if (currentTime >= _timestamps.last) {
//       setState(() {
//         _currentLyricIndex = _timestamps.length - 1;
//       });
//       _scrollToCurrentLyric();
//     }
//   }
//
//   void _updateCurrentLyric(Duration position) {
//     double currentTime = position.inSeconds.toDouble() +
//         position.inMilliseconds.remainder(1000) / 1000.0 +
//         _timeOffset;
//
//     // Log thời gian thực tế để kiểm tra
//     print('Current time: $currentTime');
//
//     if (_showIntro && currentTime >= _introEnd) {
//       setState(() {
//         _showIntro = false;
//       });
//     }
//
//     if (!_showIntro) {
//       for (int i = 0; i < _timestamps.length - 1; i++) {
//         if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
//           if (_currentLyricIndex != i) {
//             setState(() {
//               _currentLyricIndex = i;
//               _currentCharIndex = 0;
//             });
//             _scrollToCurrentLyric();
//           }
//           break;
//         }
//       }
//
//       if (currentTime >= _timestamps.last) {
//         setState(() {
//           _currentLyricIndex = _timestamps.length - 1;
//         });
//         _scrollToCurrentLyric();
//       }
//
//       _updateCurrentCharIndex(currentTime);
//     }
//   }
//
//   void _scrollToCurrentLyric() {
//     if (_scrollController.hasClients) {
//       double targetPosition = _currentLyricIndex * 50.0; // Điều chỉnh chiều cao phù hợp
//       _scrollController.animateTo(
//         targetPosition - 100, // Dòng hiện tại ở gần giữa màn hình
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _updateCurrentCharIndex(double currentTime) {
//     if (_currentLyricIndex >= _lyrics.length) return;
//
//     String currentLyric = _lyrics[_currentLyricIndex];
//     double startTime = _timestamps[_currentLyricIndex];
//     double endTime = _timestamps.length > _currentLyricIndex + 1
//         ? _timestamps[_currentLyricIndex + 1]
//         : currentTime;
//
//     double duration = endTime - startTime;
//
//     // Nếu chưa đến thời gian hiển thị câu này
//     if (currentTime < startTime) {
//       setState(() {
//         _currentCharIndex = 0;
//         _currentCharProgress = 1.0;
//       });
//       return;
//     }
//
//     // Thời gian đã trôi qua trong câu hiện tại
//     double elapsedTime = currentTime - startTime;
//
//     // Tính thời gian cho mỗi ký tự
//     double timePerChar = (duration / currentLyric.length) * 1.0; // Điều chỉnh tốc độ ký tự
//     int newCharIndex = (elapsedTime / timePerChar).floor();
//     double progress = (elapsedTime % timePerChar) / timePerChar;
//
//     // Cập nhật trạng thái hiển thị ký tự
//     if (newCharIndex != _currentCharIndex || progress != _currentCharProgress) {
//       setState(() {
//         _currentCharIndex = newCharIndex.clamp(0, currentLyric.length - 1);
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
//         title: const Text('Lyrics', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : _showIntro
//           ? Center(
//         child: Text(
//           '...',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 60.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       )
//           : ListView.builder(
//         controller: _scrollController,
//         itemCount: _lyrics.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: _buildLyricCharacters(_lyrics[index], index),
//             ),
//           );
//         },
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
//                 style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
//                   style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
  bool _showIntro = true;
  int _currentLyricIndex = 0;
  int _currentCharIndex = 0;
  double _currentCharProgress = 0.0;
  double _introEnd = 0.0;
  double _lyricsDuration = 0.0;
  double _timeOffset = 0.0; // Offset để điều chỉnh độ khớp thời gian
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchLyrics();
    widget.audioPlayer.durationStream.listen((audioDuration) {
      if (audioDuration != null) {
        double audioDurationInSeconds = audioDuration.inMilliseconds / 1000.0;

        // Kiểm tra và đồng bộ
        if (_lyricsDuration > 0.0 && (audioDurationInSeconds - _lyricsDuration).abs() > 0.1) {
          setState(() {
            _timeOffset = _lyricsDuration - audioDurationInSeconds;
          });
          print("Adjusted time offset: $_timeOffset seconds");
        }
      }
    });

    widget.audioPlayer.positionStream.listen((position) {
      _updateCurrentLyric(position);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchLyrics() async {
    try {
      final String response = await rootBundle.loadString('lib/a1/lyric.json');
      final Map<String, dynamic> data = jsonDecode(response);

      setState(() {
        _lyrics = List<String>.from(data['lyrics'].map((lyric) => lyric.toString()));
        _timestamps = List<double>.from(data['timestamps'].map((time) => time.toDouble()));
        _introEnd = data['introEnd'];
        _lyricsDuration = _timestamps.isNotEmpty ? _timestamps.last : 0.0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lyrics = ['Error loading lyrics'];
        _timestamps = [];
        _isLoading = false;
      });
      print('Error loading lyrics: $e');
    }
  }

  void _updateCurrentLyric(Duration position) {
    double currentTime = position.inMilliseconds / 1000.0 + _timeOffset;
    // double currentTime = position.inSeconds.toDouble() +
    //     position.inMilliseconds.remainder(1000) / 1000.0 +
    //     _timeOffset;

    // Log thời gian thực tế để kiểm tra
    print('Current time: $currentTime');

    if (_showIntro && currentTime >= _introEnd) {
      setState(() {
        _showIntro = false;
      });
    }
//Logic đồng bộ hóa vị trí lời bài hát
    if (_timestamps.isNotEmpty && currentTime >= _timestamps.first && currentTime <= _timestamps.last) {
      for (int i = 0; i < _timestamps.length - 1; i++) {
        if (currentTime >= _timestamps[i] && currentTime < _timestamps[i + 1]) {
          if (_currentLyricIndex != i) {
            setState(() {
              _currentLyricIndex = i;
              _currentCharIndex = 0;
            });
            _scrollToCurrentLyric();
          }
          break;
        }
      }

      if (currentTime >= _timestamps.last) {
        setState(() {
          _currentLyricIndex = _timestamps.length - 1;
        });
        _scrollToCurrentLyric();
      }

      _updateCurrentCharIndex(currentTime);
    }
  }

  void _scrollToCurrentLyric() {
    if (_scrollController.hasClients) {
      double targetPosition = _currentLyricIndex * 50.0; // Điều chỉnh chiều cao phù hợp
      _scrollController.animateTo(
        targetPosition - 100, // Dòng hiện tại ở gần giữa màn hình
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateCurrentCharIndex(double currentTime) {
    if (_currentLyricIndex >= _lyrics.length) return;

    String currentLyric = _lyrics[_currentLyricIndex];
    double startTime = _timestamps[_currentLyricIndex];
    double endTime = _timestamps.length > _currentLyricIndex + 1
        ? _timestamps[_currentLyricIndex + 1]
        : currentTime;

    double duration = endTime - startTime;

    // Nếu chưa đến thời gian hiển thị câu này
    if (currentTime < startTime) {
      setState(() {
        _currentCharIndex = 0;
        _currentCharProgress = 1.0;
      });
      return;
    }

    // Thời gian đã trôi qua trong câu hiện tại
    double elapsedTime = currentTime - startTime;

    // Tính thời gian cho mỗi ký tự
    double timePerChar = (duration / currentLyric.length) * 1.0; // Điều chỉnh tốc độ ký tự
    int newCharIndex = (elapsedTime / timePerChar).floor();
    double progress = (elapsedTime % timePerChar) / timePerChar;

    // Cập nhật trạng thái hiển thị ký tự
    if (newCharIndex != _currentCharIndex || progress != _currentCharProgress) {
      setState(() {
        _currentCharIndex = newCharIndex.clamp(0, currentLyric.length - 1);
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
        title: const Text('Lyrics', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _showIntro
          ? Center(
        child: Text(
          '... (Intro)',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        controller: _scrollController,
        itemCount: _lyrics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildLyricCharacters(_lyrics[index], index),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildLyricCharacters(String lyric, int index) {
    List<Widget> characters = [];

    for (int i = 0; i < lyric.length; i++) {
      if (index == _currentLyricIndex && i == _currentCharIndex) {
        characters.add(
          Stack(
            children: [
              Text(
                lyric[i],
                style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
