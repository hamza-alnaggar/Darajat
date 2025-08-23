// import 'package:dartz/dartz_streaming.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
// import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_state.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   final int episodeId;

//   const VideoPlayerScreen({
//     super.key,
//     required this.videoUrl,
//     required this.episodeId,
//   });

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   Duration? _videoDuration;
//   Duration _lastPosition = Duration.zero;
//   Duration _totalWatched = Duration.zero;
//   bool _watchedMoreThan50 = false;
//   bool _completed = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _videoDuration = _controller.value.duration;
//         });
//         _controller.addListener(_trackProgress);
//       });
    
//     // Initialize EpisodeDetailCubit for this episode
//     context.read<EpisodeDetailCubit>().initForEpisode(
//           episodeId: widget.episodeId,
//           isStudent: widget.isStudent,
//         );
//   }

//   void _trackProgress() {
//     if (!mounted) return;
    
//     final currentPosition = _controller.value.position;
//     _totalWatched += currentPosition - _lastPosition;
//     _lastPosition = currentPosition;

//     // Check if watched more than 50%
//     if (_videoDuration != null && !_watchedMoreThan50) {
//       final percentageWatched = _totalWatched.inMilliseconds / _videoDuration!.inMilliseconds;
//       if (percentageWatched > 0.5) {
//         setState(() {
//           _watchedMoreThan50 = true;
//         });
//       }
//     }

//     // Check if reached the end
//     if (_controller.value.isPlaying && 
//         _controller.value.position >= _controller.value.duration - const Duration(seconds: 1)) {
//       if (!_completed) {
//         setState(() {
//           _completed = true;
//         });
//         _sendCompletionToBackend();
//       }
//     }
//   }

//   void _sendCompletionToBackend() {
//     if (_completed && _watchedMoreThan50) {
//       context.read<EpisodeDetailCubit>().finishEpisode();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Video Player')),
//       body: BlocBuilder<EpisodeDetailCubit, EpisodeDetailState>(
//         builder: (context, state) {
//           return Column(
//             children: [
//               AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: VideoPlayer(_controller),
//               ),
//               // ... عناصر التحكم بالمشغل ...
//             ],
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_trackProgress);
//     _controller.dispose();
//     super.dispose();
//   }
// }