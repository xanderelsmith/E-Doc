import 'package:audioplayers/audioplayers.dart';

class RingTone {
  final AudioPlayer audioPlayer = AudioPlayer();
  playCallingTone() {
    audioPlayer.play(AssetSource('asset/audio/incoming.wav'));
  }

  playWaitingTone() {
    audioPlayer.play(AssetSource('asset/audio/waiting.wav'));
  }
}
