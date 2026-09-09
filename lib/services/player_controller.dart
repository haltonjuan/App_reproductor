import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

/// Singleton: una sola instancia de AudioPlayer para toda la app.
/// Evita crear/destruir players (causa común de lag y memory leaks).
class PlayerController {
  PlayerController._internal();
  static final PlayerController instance = PlayerController._internal();

  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> queue = [];
  int currentIndex = 0;

  SongModel? get currentSong =>
      queue.isNotEmpty && currentIndex < queue.length
          ? queue[currentIndex]
          : null;

  Future<void> playQueue(List<SongModel> songs, int startIndex) async {
    queue = songs;
    currentIndex = startIndex;
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final song = currentSong;
    if (song == null) return;
    await audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(song.uri ?? song.data)),
    );
    audioPlayer.play();
  }

  Future<void> next() async {
    if (currentIndex < queue.length - 1) {
      currentIndex++;
      await _playCurrent();
    }
  }

  Future<void> previous() async {
    if (currentIndex > 0) {
      currentIndex--;
      await _playCurrent();
    }
  }

  void togglePlayPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }
}
