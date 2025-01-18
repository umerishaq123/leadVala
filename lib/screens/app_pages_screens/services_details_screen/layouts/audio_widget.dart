import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '00:00';
  String get _positionText => _position?.toString().split('.').first ?? '00:00';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _initStreams();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initStreams() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen(
          (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
          setState(() {
            _playerState = state;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Audio Slider
              Slider(
                value: (_position != null &&
                    _duration != null &&
                    _position!.inMilliseconds > 0 &&
                    _position!.inMilliseconds < _duration!.inMilliseconds)
                    ? _position!.inMilliseconds / _duration!.inMilliseconds
                    : 0.0,
                onChanged: (value) {
                  final duration = _duration;
                  if (duration == null) return;
                  final position = value * duration.inMilliseconds;
                  _audioPlayer.seek(Duration(milliseconds: position.round()));
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white.withOpacity(0.5),
              ),

              // Position and Duration Text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _positionText,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    _durationText,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Play, Pause, Stop Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _controlButton(
                    icon: Icons.play_arrow_rounded,
                    onPressed: _isPlaying ? null : _play,
                    isActive: !_isPlaying,
                  ),
                  _controlButton(
                    icon: Icons.pause_rounded,
                    onPressed: _isPlaying ? _pause : null,
                    isActive: _isPlaying,
                  ),
                  _controlButton(
                    icon: Icons.stop_rounded,
                    onPressed: _isPlaying || _isPaused ? _stop : null,
                    isActive: _isPlaying || _isPaused,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isActive,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blueAccent, backgroundColor: isActive ? Colors.white : Colors.white.withOpacity(0.5), shape: CircleBorder(),
        padding: EdgeInsets.all(16),
      ),
      child: Icon(icon, size: 36, color: isActive ? Colors.blueAccent : Colors.grey),
    );
  }

  Future<void> _play() async {
    await _audioPlayer.setSourceUrl(widget.audioUrl);
    await _audioPlayer.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
}
