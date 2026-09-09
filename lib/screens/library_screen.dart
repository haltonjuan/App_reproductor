import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_theme.dart';
import '../services/player_controller.dart';
import '../services/playlist_service.dart';
import 'player_screen.dart';
import 'videos_screen.dart';
import 'playlists_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final PlaylistService _playlistService = PlaylistService();
  bool _permisoOk = false;
  List<SongModel> _songs = [];

  @override
  void initState() {
    super.initState();
    _pedirPermisoYCargar();
  }

  Future<void> _pedirPermisoYCargar() async {
    final statusAudio = await Permission.audio.request();
    await Permission.videos.request(); // permiso para videos también
    if (statusAudio.isGranted) {
      final songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
      setState(() {
        _songs = songs;
        _permisoOk = true;
      });
    } else {
      setState(() => _permisoOk = false);
    }
  }

  Future<void> _mostrarMenuAgregarPlaylist(SongModel song) async {
    final playlists = await _playlistService.obtenerPlaylists();
    if (!mounted) return;
    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero crea una playlist en la pestaña Playlists')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: playlists.keys.map((nombre) {
          return ListTile(
            leading: const Icon(Icons.queue_music, color: AppTheme.red),
            title: Text(nombre),
            onTap: () async {
              await _playlistService.agregarCancion(nombre, song.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Agregada a "$nombre"')),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              Icon(Icons.eco, color: AppTheme.red),
              SizedBox(width: 8),
              Text('Leek', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: AppTheme.red,
            labelColor: AppTheme.red,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Canciones'),
              Tab(text: 'Videos'),
              Tab(text: 'Playlists'),
            ],
          ),
        ),
        body: !_permisoOk
            ? Center(
                child: ElevatedButton(
                  onPressed: _pedirPermisoYCargar,
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red),
                  child: const Text('Conceder permiso de archivos'),
                ),
              )
            : TabBarView(
                children: [
                  _buildSongList(),
                  const VideosScreen(),
                  const PlaylistsScreen(),
                ],
              ),
      ),
    );
  }

  Widget _buildSongList() {
    if (_songs.isEmpty) {
      return const Center(child: Text('No se encontró música'));
    }
    return ListView.builder(
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final song = _songs[index];
        return ListTile(
          leading: QueryArtworkWidget(
            id: song.id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white54),
          ),
          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(song.artist ?? 'Desconocido',
              maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: () => _mostrarMenuAgregarPlaylist(song),
          ),
          onTap: () async {
            await PlayerController.instance.playQueue(_songs, index);
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlayerScreen()),
              );
            }
          },
        );
      },
    );
  }
}
