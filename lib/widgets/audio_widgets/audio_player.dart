import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:funny_chat/ui/helpers/datetime_manager.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String fileUrl;
  final bool isMe;

  const AudioPlayerWidget({super.key, required this.fileUrl, required this.isMe});

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });
    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        _isPlaying = s == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTimestamp(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % AppNumbers.hour;
    return '${DateTimeManager.padLeftWithZero(minutes)}:${DateTimeManager.padLeftWithZero(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    var userColor = Theme.of(context).colorScheme.secondaryContainer;
    var userFriendColor = Theme.of(context).colorScheme.onSecondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: widget.isMe ? userColor : userFriendColor,
          ),
          onPressed: () async {
            if (_isPlaying) {
              await _audioPlayer.pause();
            } else {
              await _audioPlayer.play(UrlSource(widget.fileUrl));
            }
          },
        ),
        StreamBuilder<Duration>(
          stream: _audioPlayer.onPositionChanged,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            return Slider(
              value: position.inMilliseconds.toDouble(),
              min: AppNumbers.zero,
              max: _duration.inMilliseconds.toDouble(),
              onChanged: (double value) async {
                final newPosition = Duration(milliseconds: value.toInt());
                await _audioPlayer.seek(newPosition);
              },
            );
          },
        ),
        Text(
          "${formatTimestamp(_position.inMilliseconds)} / ${formatTimestamp(_duration.inMilliseconds)}",
          style: TextStyle(
            color: widget.isMe ? userColor : userFriendColor,
            fontSize: AppNumbers.audioDurationVisualSize,
          ),
        ),
      ],
    );
  }
}
