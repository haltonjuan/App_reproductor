import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../theme/app_theme.dart';
import '../services/player_controller.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;
    final song = controller.currentSong;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(icon: const Icon(Icons.equalizer), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: song != null
                  ? QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: 340,
                      artworkWidth: double.infinity,
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Container(
                        height: 340,
                        color: AppTheme.surface,
                        child: const Icon(Icons.music_note, size: 80),
                      ),
                    )
                  : Container(height: 340, color: AppTheme.surface),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song?.title ?? 'Sin reproducción',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song?.artist ?? '',
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 16),
            StreamBuilder<Duration>(
              stream: controller.audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final total = controller.audioPlayer.duration ?? Duration.zero;
                return ProgressBar(
                  progress: position,
                  total: total,
                  baseBarColor: Colors.white24,
                  progressBarColor: AppTheme.red,
                  thumbColor: AppTheme.red,
                  onSeek: (d) => controller.audioPlayer.seek(d),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: controller.previous,
                ),
                StreamBuilder<bool>(
                  stream: controller.audioPlayer.playingStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return IconButton(
                      iconSize: 64,
                      icon: Icon(
                        playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: AppTheme.red,
                      ),
                      onPressed: controller.togglePlayPause,
                    );
                  },
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.skip_next),
                  onPressed: controller.next,
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Letras'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white70),
                ),
                IconButton(icon: const Icon(Icons.queue_music), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
