import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomChewieControls extends StatefulWidget {
  @override
  State<CustomChewieControls> createState() => _CustomChewieControlsState();
}

bool _isPause = false;

class _CustomChewieControlsState extends State<CustomChewieControls> {
  late VideoPlayerController videoController;
  String position = '';
  String duration = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    videoController = ChewieController.of(context)!.videoPlayerController;
    videoController.addListener(() {
      setState(() {
        position = _formatDuration(videoController.value.position);
        duration = _formatDuration(videoController.value.duration);
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes);
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Time stamps above progress bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                position,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                duration,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        // Progress bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).colorScheme.error,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: Theme.of(context).colorScheme.error,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: videoController.value.position.inMilliseconds.toDouble(),
              min: 0.0,
              max: videoController.value.duration.inMilliseconds.toDouble(),
              onChanged: (value) {
                videoController.seekTo(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
        ),
        // Control buttons
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(bottom: 5),
          height: MediaQuery.of(context).size.height * 0.11,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35.0),
              topRight: Radius.circular(35.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.replay_10,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  videoController.seekTo(
                      videoController.value.position - Duration(seconds: 10));
                },
              ),
              IconButton(
                icon: Icon(
                  _isPause
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_filled_rounded,
                  color: Colors.black,
                  size: 80,
                ),
                onPressed: () {
                  setState(() {
                    _isPause = !_isPause;
                  });
                  _isPause ? videoController.play() : videoController.pause();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.forward_10,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  videoController.seekTo(
                      videoController.value.position + Duration(seconds: 10));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
