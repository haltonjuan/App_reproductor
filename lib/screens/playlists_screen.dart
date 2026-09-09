import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/playlist_service.dart';
import 'playlist_detail_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  final PlaylistService _service = PlaylistService();
  Map<String, List<int>> _playlists = {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final playlists = await _service.obtenerPlaylists();
    setState(() => _playlists = playlists);
  }

  Future<void> _crearPlaylistDialog() async {
    final controlador = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Nueva playlist'),
        content: TextField(
          controller: controlador,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nombre de la playlist'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (controlador.text.trim().isNotEmpty) {
                await _service.crearPlaylist(controlador.text.trim());
                if (context.mounted) Navigator.pop(context);
                _cargar();
              }
            },
            child: const Text('Crear', style: TextStyle(color: AppTheme.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.red,
        onPressed: _crearPlaylistDialog,
        child: const Icon(Icons.add),
      ),
      body: _playlists.isEmpty
          ? const Center(child: Text('Aún no tienes playlists'))
          : ListView(
              children: _playlists.entries.map((entrada) {
                return ListTile(
                  leading: const Icon(Icons.queue_music, color: AppTheme.red),
                  title: Text(entrada.key),
                  subtitle: Text('${entrada.value.length} canciones'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await _service.eliminarPlaylist(entrada.key);
                      _cargar();
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaylistDetailScreen(nombre: entrada.key),
                      ),
                    );
                    _cargar();
                  },
                );
              }).toList(),
            ),
    );
  }
}
