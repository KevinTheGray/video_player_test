import 'dart:html' as html;
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:videotest/video_data.dart';

Future<void> main() async {
  runApp(VideoApp());
}

class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blob = html.Blob([data]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Player(url),
      ),
    );
  }
}

class Player extends StatefulWidget {
  const Player(this.url, {Key key}) : super(key: key);
  final String url;
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? ClipRect(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fromRect(
                    rect: Rect.fromLTWH(100, 100, 400, 100),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
