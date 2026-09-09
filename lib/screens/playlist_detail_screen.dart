import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../theme/app_theme.dart';
import '../services/playlist_service.dart';
import '../services/player_controller.dart';
import 'player_screen.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final String nombre;
  const PlaylistDetailScreen({super.key, required this.nombre});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final PlaylistService _service = PlaylistService();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _canciones = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final playlists = await _service.obtenerPlaylists();
    final ids = playlists[widget.nombre] ?? [];
    final todas = await _audioQuery.querySongs();
    setState(() {
      _canciones = todas.where((c) => ids.contains(c.id)).toList();
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nombre)),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: AppTheme.red))
          : _canciones.isEmpty
              ? const Center(child: Text('Playlist vacía.\nAgrega canciones desde la biblioteca.'))
              : ListView.builder(
                  itemCount: _canciones.length,
                  itemBuilder: (context, index) {
                    final song = _canciones[index];
                    return ListTile(
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(Icons.music_note),
                      ),
                      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(song.artist ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () async {
                          await _service.quitarCancion(widget.nombre, song.id);
                          _cargar();
                        },
                      ),
                      onTap: () async {
                        await PlayerController.instance.playQueue(_canciones, index);
                        if (context.mounted) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const PlayerScreen()));
                        }
                      },
                    );
                  },
                ),
    );
  }
}
