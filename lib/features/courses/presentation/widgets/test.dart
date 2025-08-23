// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';

// class InlineVideoPlayer extends StatefulWidget {
//   final EpisodeModel episode;
//   final bool isStudent;

//   const InlineVideoPlayer({
//     super.key,
//     required this.episode,
//     required this.isStudent,
//   });

//   @override
//   State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
// }

// class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
//   VideoPlayerController? _controller;
//   bool _isPlaying = false;
//   bool _showControls = true;
//   bool _isLoading = false;
//   bool _isBuffering = false;
//   double _playbackPosition = 0.0;
//   double _totalDuration = 0.0;
//   bool _isInitialized = false;
//   bool _isDisposed = false;
//   Timer? _progressCheckTimer;
//   Timer? _hideControlsTimer;
//   EpisodeModel? _currentEpisode;
//   StreamSubscription<Uint8List>? _videoSubscription;
//   IOSink? _sink;
//   int _totalBytesWritten = 0;
//   String? _tempFilePath;
//   String? _errorMessage;
//   bool _isSwitchingEpisode = false;

//   bool _isLoadingStarted = false;

//   double _lastSentProgress = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _currentEpisode = widget.episode;
//     _setupProgressTracking();
//   }

//   @override
//   void didUpdateWidget(InlineVideoPlayer oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.episode.id != widget.episode.id) {
//       _isSwitchingEpisode = true;
//       _resetPlayer();
//       _currentEpisode = widget.episode;
//       _setupProgressTracking();
//       _isLoadingStarted = false; // reset so new episode can start loading

//       // small delay to show switching state to the user
//       Future.delayed(const Duration(milliseconds: 300), () {
//         if (mounted) setState(() => _isSwitchingEpisode = false);
//       });
//     }
//   }

//   void _setupProgressTracking() {
//     _progressCheckTimer?.cancel();
//     _progressCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       if (_controller != null &&
//           _controller!.value.isInitialized &&
//           _totalDuration > 0) {
//         final progress = _playbackPosition / _totalDuration;
//         try {
//           context.read<EpisodeDetailCubit>().updateProgress(progress);
//           context.read<EpisodeDetailCubit>().checkCompletion(widget.episode.id);
//         } catch (_) {
//           // Cubit may not be available in tests; ignore safely
//         }
//       }
//     });
//   }

//   Future<void> _initializePlayer(Stream<Uint8List> videoStream) async {
//     if (_isDisposed) return;
//     if (_isLoadingStarted) return; 

//     setState(() {
//       _isLoading = true;
//       _isLoadingStarted = true; // means we've started a load attempt
//       _errorMessage = null;
//     });

//     try {
//       final tempDir = await getTemporaryDirectory();
//       _tempFilePath = '${tempDir.path}/temp_video_${widget.episode.id}.mp4';
//       final tempFile = File(_tempFilePath!);

//       if (await tempFile.exists()) await tempFile.delete();

//       _sink = tempFile.openWrite();
//       const initialBufferSize = 256 * 1024; // 256KB - start earlier for snappy playback

//       _videoSubscription = videoStream.listen(
//         (chunk) async {
//               debugPrint('video chunk: ${chunk.length} bytes for episode ${widget.episode.id}');

//           if (_isDisposed) return;
//           _sink?.add(chunk);
//           _totalBytesWritten += chunk.length;

//           // initialize controller once we've got some bytes
//           if (_controller == null && _totalBytesWritten >= initialBufferSize) {
//             await _sink?.flush();
//             await _initializeVideoController(_tempFilePath!);
//           }

//           if (mounted) setState(() {});
//         },
//         onDone: () async {
//               debugPrint('videoStream onDone for episode ${widget.episode.id}');

//           // finish writing file and if controller hasn't been initialized yet, try now
//           await _sink?.flush();
//           await _sink?.close();
//           _sink = null;

//           if (_controller == null && !_isDisposed) {
//             await _initializeVideoController(_tempFilePath!);
//           }
//         },
//         onError: (error) async {
//               debugPrint('videoStream error for episode ${widget.episode.id}: $error');

//           await _sink?.close();
//           _sink = null;
//           if (mounted && !_isDisposed) {
//             setState(() {
//               _isLoading = false;
//               _errorMessage = 'Video load failed: $error';
//             });
//           }
//         },
//         cancelOnError: true,
//       );
//     } catch (e) {
//       if (mounted && !_isDisposed) {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Video initialization failed: $e';
//         });
//       }
//     }
//   }

//   Future<void> _initializeVideoController(String filePath) async {
//     if (_isDisposed) return;

//     try {
//       if (_controller != null) return;

//       final file = File(filePath);
//       if (!await file.exists()) {
//         return;
//       }

//       final controller = VideoPlayerController.file(file);

//       // set looping first (safe) then initialize
//       controller.setLooping(false);

//       await controller.initialize();

//       if (!mounted || _isDisposed) {
//         // If widget gone, dispose created controller
//         await controller.dispose();
//         return;
//       }

//       _controller = controller;

//       setState(() {
//         _isLoading = false;
//         _isInitialized = true; // mark initialized only after controller is ready
//         _controller?.play();
//         _isPlaying = true;
//         _startHideControlsTimer();
//         _totalDuration = _controller!.value.duration.inMilliseconds.toDouble();
//       });

//       _controller?.addListener(_videoPlayerListener);
//     } catch (e) {
//       if (mounted && !_isDisposed) {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Video player error: $e';
//         });
//       }
//     }
//   }

//   void _videoPlayerListener() {
//     if (!mounted || _controller == null) return;

//     final value = _controller!.value;
//     if (!value.isInitialized) return;

//     setState(() {
//       _isBuffering = value.isBuffering;
//       _playbackPosition = value.position.inMilliseconds.toDouble();
//       _totalDuration = value.duration.inMilliseconds.toDouble();
//     });

//     if (_totalDuration > 0) {
//       final progress = _playbackPosition / _totalDuration;
//       // send progress when it moves forward by >= 10%
//       if (progress - _lastSentProgress >= 0.1 || (progress - _lastSentProgress) < 0 && progress > 0.0) {
//         _lastSentProgress = progress;
//         try {
//           context.read<EpisodeDetailCubit>().updateProgress(progress);
//         } catch (_) {}
//       }
//     }
//   }

//   void _startHideControlsTimer() {
//     _hideControlsTimer?.cancel();
//     _hideControlsTimer = Timer(const Duration(seconds: 3), () {
//       if (mounted && _isPlaying) {
//         setState(() => _showControls = false);
//       }
//     });
//   }

//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       _showControls = true;
//     });
//     if (_isPlaying) {
//       _controller?.play();
//       _startHideControlsTimer();
//     } else {
//       _controller?.pause();
//       _hideControlsTimer?.cancel();
//     }
//   }

//   void _toggleControlsVisibility() {
//     setState(() => _showControls = !_showControls);
//     if (_showControls) _startHideControlsTimer();
//   }

//   void _resetPlayer() {
//     _isInitialized = false;
//     _isLoading = false;
//     _isPlaying = false;
//     _showControls = true;
//     _totalBytesWritten = 0;
//     _isLoadingStarted = false;
//     _lastSentProgress = 0.0;

//     try {
//       _controller?.removeListener(_videoPlayerListener);
//     } catch (_) {}

//     try {
//       _controller?.pause();
//     } catch (_) {}

//     try {
//       _controller?.dispose();
//     } catch (_) {}

//     _controller = null;

//     _videoSubscription?.cancel();
//     _videoSubscription = null;

//     try {
//       _sink?.close();
//     } catch (_) {}
//     _sink = null;

//     _cleanupTempFile();

//     _progressCheckTimer?.cancel();
//     _hideControlsTimer?.cancel();

//     _playbackPosition = 0.0;
//     _totalDuration = 0.0;
//     _errorMessage = null;
//   }

//   Future<void> _cleanupTempFile() async {
//     if (_tempFilePath != null) {
//       try {
//         final file = File(_tempFilePath!);
//         if (await file.exists()) await file.delete();
//       } catch (e) {
//         debugPrint('Error deleting temp file: $e');
//       }
//       _tempFilePath = null;
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.removeListener(_videoPlayerListener);
//     _progressCheckTimer?.cancel();
//     _hideControlsTimer?.cancel();
//     _videoSubscription?.cancel();
//     _controller?.dispose();
//     try {
//       _sink?.close();
//     } catch (_) {}
//     _cleanupTempFile();
//     _isDisposed = true;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<EpisodeDetailCubit>();

//   // Reset cubit when episode changes
//   if (cubit.episodeId != widget.episode.id) {
//     cubit.reset();
//     cubit.getEpisode(widget.episode.id);
//     cubit.loadEpisodeMedia(widget.episode.id);
//     _resetPlayer();
//     _isLoadingStarted = false;
//   }

//   // Initialize player when stream is available
//   if (cubit.videoStream != null && 
//       !_isInitialized && 
//       !_isLoading && 
//       !_isLoadingStarted) {
//     _isLoadingStarted = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _initializePlayer(cubit.videoStream!);
//     });
//   }

//   return _buildPlayerUI(context, cubit);
//   }

//   Widget _buildPlayerUI(BuildContext context, EpisodeDetailCubit cubit) {
//     return AspectRatio(
//       aspectRatio: 16 / 9,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Poster background during switching or before playback
//           if (_isSwitchingEpisode || _controller == null || !_controller!.value.isInitialized)
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: cubit.poster != null
//                   ? Image.memory(
//                       key: ValueKey(widget.episode.id),
//                       cubit.poster!,
//                       fit: BoxFit.cover,
//                     )
//                   : const Icon(Icons.play_arrow),
//             ),

//           // Video player
//           if (_controller != null && _controller!.value.isInitialized)
//             GestureDetector(
//               onTap: _toggleControlsVisibility,
//               child: VideoPlayer(_controller!),
//             ),

//           // Loading indicator
//           if (_isLoading || _isBuffering)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircularProgressIndicator(),
//                   if (_totalBytesWritten > 0)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         'Downloaded: ${_formatBytes(_totalBytesWritten)}',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           // Error message
//           if (_errorMessage != null)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black54,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         _errorMessage!,
//                         style: const TextStyle(color: Colors.white),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (cubit.videoStream != null) {
//                             // allow retry
//                             _initializePlayer(cubit.videoStream!);
//                           }
//                         },
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//           // Video controls
//           if (_showControls && _controller?.value.isInitialized == true)
//             AnimatedOpacity(
//               opacity: _showControls ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 300),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Colors.black54, Colors.transparent],
//                   ),
//                 ),
//                 child: Center(
//                   child: IconButton(
//                     icon: Icon(
//                       _isPlaying ? Icons.pause : Icons.play_arrow,
//                       size: 60,
//                       color: Colors.white,
//                     ),
//                     onPressed: _togglePlayPause,
//                   ),
//                 ),
//               ),
//             ),

//           // Episode switching indicator
//           if (_isSwitchingEpisode)
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   String _formatBytes(int bytes) {
//     if (bytes < 1024) return '$bytes B';
//     if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
//     return '${(bytes / 1048576).toStringAsFixed(1)} MB';
//   }
// }
