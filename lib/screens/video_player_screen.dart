import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../theme/app_theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _listo = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    _controller = VideoPlayerController.file(File(widget.video.data));
    await _controller.initialize();
    setState(() => _listo = true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.video.displayName, overflow: TextOverflow.ellipsis),
      ),
      body: Center(
        child: _listo
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: AppTheme.red,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(color: AppTheme.red),
      ),
      floatingActionButton: _listo
          ? FloatingActionButton(
              backgroundColor: AppTheme.red,
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
            )
          : null,
    );
  }
}
