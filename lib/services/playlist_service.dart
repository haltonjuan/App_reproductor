import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda playlists como: { "Mi playlist": [idCancion1, idCancion2, ...] }
class PlaylistService {
  static const _clave = 'leek_playlists';

  Future<Map<String, List<int>>> obtenerPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);
    if (texto == null) return {};
    final Map<String, dynamic> data = jsonDecode(texto);
    return data.map((k, v) => MapEntry(k, List<int>.from(v)));
  }

  Future<void> _guardar(Map<String, List<int>> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clave, jsonEncode(playlists));
  }

  Future<void> crearPlaylist(String nombre) async {
    final playlists = await obtenerPlaylists();
    playlists[nombre] = [];
    await _guardar(playlists);
  }

  Future<void> eliminarPlaylist(String nombre) async {
    final playlists = await obtenerPlaylists();
    playlists.remove(nombre);
    await _guardar(playlists);
  }

  Future<void> agregarCancion(String nombrePlaylist, int songId) async {
    final playlists = await obtenerPlaylists();
    if (playlists[nombrePlaylist] == null) return;
    if (!playlists[nombrePlaylist]!.contains(songId)) {
      playlists[nombrePlaylist]!.add(songId);
      await _guardar(playlists);
    }
  }

  Future<void> quitarCancion(String nombrePlaylist, int songId) async {
    final playlists = await obtenerPlaylists();
    playlists[nombrePlaylist]?.remove(songId);
    await _guardar(playlists);
  }
}
