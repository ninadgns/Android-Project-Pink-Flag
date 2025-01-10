import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


class VideoPlayerWindow extends StatefulWidget {
  const VideoPlayerWindow({super.key});

  @override
  _VideoPlayerWindowState createState() => _VideoPlayerWindowState();
}

class _VideoPlayerWindowState extends State<VideoPlayerWindow> {
  VideoPlayerController?
      _videoPlayerController; // Controller for managing video playback.
  ChewieController?
      _chewieController; // Controller for managing Chewie-specific features.

  @override
  void initState() {
    super.initState();

    // Initialize the VideoPlayerController with the network video.
    _videoPlayerController = VideoPlayerController.network(
        'https://www.sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });

    // Initialize the ChewieController with additional features, including custom controls.
    _chewieController = ChewieController(
      videoPlayerController:
          _videoPlayerController!, // Use the video player controller.
      aspectRatio: 16 / 9, // Maintain video aspect ratio.
      autoPlay: true, // Automatically play the video on load.
      looping: false, // Do not loop the video.
      showControls: true, // Display player controls.

      allowFullScreen: true, // Enable full-screen toggle.
      allowPlaybackSpeedChanging:
          true, // Allow the user to change playback speed.
      playbackSpeeds: [
        0.5,
        1.0,
        1.5,
        2.0
      ], // Define available playback speed options.
      allowMuting: true, // Enable mute/unmute functionality.
      showControlsOnInitialize: true, // Show controls when the video starts.
      // customControls: CustomChewieControls(), // Use custom-defined controls.
      placeholder: AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: Container(
          color: Colors.transparent,
          // height: double.maxFinite, // Black background while loading.
          // width: double.maxFinite,
          child: const Center(
            child: Text(
              'Loading Video...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor:
            Colors.blue, // Color of the played portion of the progress bar.
        handleColor: Colors.blueAccent, // Color of the progress handle.
        bufferedColor:
            Colors.grey, // Color of the buffered portion of the progress bar.
        // backgroundColor: Colors.black, // Color of the unplayed portion of the progress bar.
      ),
      // overlay: Center(
      //   child: Icon(
      //     Icons.play_circle_outline, // Overlay play icon.
      //     size: 100,
      //     color: Colors.white.withOpacity(0.5),
      //   ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Container(
                color: Colors.transparent,
                // padding: EdgeInsets.all(16.0),
                child: const Text(
                  'Pumpkin Soup Recipe',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose both controllers to free up resources.
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
