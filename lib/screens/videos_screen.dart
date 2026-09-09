import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../theme/app_theme.dart';
import 'video_player_screen.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<VideoModel> _videos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarVideos();
  }

  Future<void> _cargarVideos() async {
    // El permiso ya se pidió en LibraryScreen antes de llegar aquí.
    final videos = await _audioQuery.queryVideos(
      sortType: VideoSortType.DISPLAY_NAME,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    setState(() {
      _videos = videos;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.red));
    }
    if (_videos.isEmpty) {
      return const Center(child: Text('No se encontraron videos'));
    }
    // GridView: vista en miniaturas, mejor rendimiento que lista larga con thumbnails grandes
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoPlayerScreen(video: video),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: QueryArtworkWidget(
                    id: video.id,
                    type: ArtworkType.VIDEO,
                    artworkFit: BoxFit.cover,
                    artworkWidth: double.infinity,
                    artworkHeight: double.infinity,
                    nullArtworkWidget: Container(
                      color: AppTheme.surface,
                      child: const Icon(Icons.videocam, color: Colors.white54, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                video.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }
}
