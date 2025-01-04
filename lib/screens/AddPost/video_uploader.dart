import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoUploader extends StatefulWidget {
  final Function(XFile?) onVideoSelected;

  const VideoUploader({super.key, required this.onVideoSelected});

  @override
  State<VideoUploader> createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  XFile? _selectedVideo;
  VideoPlayerController? _videoController;

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedVideo = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedVideo != null) {
      print('Selected Video Path: ${pickedVideo.path}'); // Log the path
      setState(() {
        _selectedVideo = pickedVideo;
      });
      await _initializeVideoPlayer();
      widget.onVideoSelected(_selectedVideo); // Notify parent about the video selection
    }
  }


  Future<void> _initializeVideoPlayer() async {
    if (_selectedVideo != null) {
      // Dispose of the previous video controller if it exists
      if (_videoController != null) {
        await _videoController!.dispose();
      }

      _videoController = VideoPlayerController.file(File(_selectedVideo!.path));

      try {
        await _videoController!.initialize();
        setState(() {});
      } catch (e) {
        // Show error if video fails to initialize
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load video. Please try again.')),
        );
        setState(() {
          _selectedVideo = null; // Reset video on failure
        });
        widget.onVideoSelected(null); // Notify parent about the failure
      }
    }
  }

  void _deleteVideo() {
    setState(() {
      _selectedVideo = null;
      _videoController?.dispose();
      _videoController = null;
    });
    widget.onVideoSelected(null); // Notify parent that the video has been removed
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recipe Video',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickVideo,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _selectedVideo == null
                ? const Center(
              child: Text(
                'Tap to upload a video',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : Stack(
              children: [
                if (_videoController != null &&
                    _videoController!.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: VideoPlayer(_videoController!),
                  )
                else if (_videoController != null)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _deleteVideo,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                if (_videoController != null &&
                    _videoController!.value.isInitialized &&
                    !_videoController!.value.isPlaying)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _videoController!.play();
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.play_circle_fill,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
