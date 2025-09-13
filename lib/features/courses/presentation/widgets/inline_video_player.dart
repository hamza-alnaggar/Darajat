import 'dart:async';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_state.dart';
import 'package:video_player/video_player.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class InlineVideoPlayer extends StatefulWidget {
  final EpisodeModel episode;
  final bool isStudent;
  final bool isCopy;

  const InlineVideoPlayer({
    super.key,
    required this.episode,
    required this.isStudent,
    required this.isCopy,
  });

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  bool _isLoading = false;
  bool tryWached = false;
  EpisodeModel? currentEpisode;
  bool _isBuffering = false;
  Timer? _hideControlsTimer;
  StreamSubscription<Uint8List>? _videoSubscription;
  bool _isInitialized = false;
  IOSink? _sink;
  bool _isDisposed = false;
  Duration _playbackPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _progressCheckTimer;
  Stream<Uint8List>? _currentVideoStream;

  @override
  void initState() {
    super.initState();
    context.read<EpisodeDetailCubit>().episode = widget.episode;
    currentEpisode = widget.episode;
  }

  @override
  void didUpdateWidget(InlineVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.episode.id != widget.episode.id) {
      _resetPlayer();
      _initializeNewStream();
    }
  }

  Future<void> _initializeNewStream() async {
    final cubit = context.read<EpisodeDetailCubit>();
    try {
      await cubit.loadEpisodeMedia(widget.episode.id, true, widget.isCopy);
      final newStream = cubit.videoStream;
      setState(() {
        _currentVideoStream = newStream;
      });
      _initializePlayer(newStream!);
    } catch (e) {
      print("Error getting video stream: $e");
    }
  }

  Future<void> _initializePlayer(Stream<Uint8List> videoStream) async {
    if (_isInitialized || _isDisposed) return;
    setState(() {
      _isLoading = true;
      _isInitialized = true;
    });
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFilePath =
          '${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final tempFile = File(tempFilePath);

      _sink = tempFile.openWrite();

      _videoSubscription = videoStream.listen(
        (chunk) {
          if (_isDisposed) return;
          _sink?.add(chunk);
          if (mounted) {
            setState(() {});
          }
        },
        onDone: () async {
          await _sink?.flush();
          await _sink?.close();
          _sink = null;

          if (_isDisposed) {
            tempFile.delete().ignore();
            return;
          }

          if (mounted) {
            _initializeVideoController(tempFile.path);
          }
        },
        onError: (error) async {
          await _sink?.close();
          _sink = null;

          if (_isDisposed) return;

          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل تحميل الفيديو: $error')),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      print("Video initialization error: $e");
      print(stackTrace);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تهيئة الفيديو: ${e.toString()}")),
        );
      }
    }
  }

  void _initializeVideoController(String filePath) {
    _controller = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _totalDuration = _controller!.value.duration;
            _playbackPosition = _controller!.value.position;
            _controller!.addListener(() {
              if (mounted && _controller!.value.isInitialized) {
                setState(() {
                  _playbackPosition = _controller!.value.position;
                });
                if (widget.isStudent && !widget.episode.isWatched!) {
                  _checkVideoCompletion();
                }
              }
            });
          });
        }
      })
      ..setLooping(false);
  }

  void _checkVideoCompletion() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final position = _controller!.value.position;
    final duration = _controller!.value.duration;

    if (duration.inSeconds > 0) {
      final progress = position.inSeconds / duration.inSeconds;

      context.read<EpisodeDetailCubit>().updateProgress(progress);

      if (progress >= 0.5 && !tryWached ) {
        tryWached = true;
        setState(() {
        });
        context.read<EpisodeDetailCubit>().checkCompletion(widget.episode.id);
        
      }
    }
  }

  void _seekToPosition(double value) {
    if (_controller == null) return;

    final position = value * _totalDuration.inMilliseconds;
    _controller!.seekTo(Duration(milliseconds: position.toInt()));

    setState(() {
      _playbackPosition = Duration(milliseconds: position.toInt());
      _showControls = true;
    });
    _startHideControlsTimer();
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    setState(() {
      _showControls = true;
    });

    if (_controller!.value.isPlaying) {
      _controller!.pause();
      _hideControlsTimer?.cancel();
    } else {
      _controller!.play();
      _startHideControlsTimer();
    }
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
    
    if (_showControls) {
      _startHideControlsTimer();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _toggleFullScreen() async {
    if (_controller == null) return;

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
          controller: _controller!,
          episodeTitle: widget.episode.title,
          onExitFullScreen: _exitFullScreen,
        ),
      ),
    );

    await _exitFullScreen();
  }

  Future<void> _exitFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  void _resetPlayer() {
    _isInitialized = false;
    _isLoading = false;
    _showControls = true;

    _videoSubscription?.cancel();
    _sink?.close();
    _sink = null;
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _videoSubscription?.cancel();
    _controller?.dispose();
    _sink?.close();
    _progressCheckTimer?.cancel();
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EpisodeDetailCubit, EpisodeDetailState>(
      listener: (context, state) {
        if (state is EpisodeDetailLoaded)
          setState(() {
            currentEpisode = state.episode.episodeModel;
          });
        if (state is EpisodeDetailError) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              color: CustomColors.backgroundColor,
              title: 'On Snap!',
              message: state.message,
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        final cubit = context.read<EpisodeDetailCubit>();
        if (cubit.videoStream != null) {
          if (_currentVideoStream == null && !_isInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeNewStream();
            });
          }
        }
        return _buildPlayerUI(context, cubit.poster);
      },
    );
  }

  Widget _buildPlayerUI(BuildContext context, Uint8List? poster) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BlocBuilder<EpisodeDetailCubit, EpisodeDetailState>(
        builder: (context, state) {
          if (state is EpisodeDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return _buildVideoContent(poster);
        },
      ),
    );
  }

  Widget _buildVideoContent(Uint8List? poster) {
    return GestureDetector(
      onTap: _toggleControlsVisibility,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video or poster background
          if (_controller == null || !_controller!.value.isInitialized)
            poster != null
                ? Image.memory(
                    poster,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          if (_controller != null && _controller!.value.isInitialized)
            VideoPlayer(_controller!),

          // Controls overlay
          if (_showControls) _buildControlsOverlay(),

          // Loading indicator
          if (_isLoading || _isBuffering)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.videocam_off, color: Colors.white54, size: 48),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: IconButton(
                  icon: Icon(
                    _controller != null && 
                    _controller!.value.isInitialized && 
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 60,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
            ),
            if (_controller != null && _controller!.value.isInitialized)
              Positioned(
                bottom: -0,
                left: 0,
                right: 0,
                child: _buildProgressBar(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            _formatDuration(_playbackPosition),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Slider(
        value: _totalDuration.inMilliseconds > 0
            ? _playbackPosition.inMilliseconds / _totalDuration.inMilliseconds
            : 0.0,
        onChanged: _seekToPosition,
        onChangeStart: (_) => _hideControlsTimer?.cancel(),
        onChangeEnd: (_) => _startHideControlsTimer(),
        min: 0.0,
        max: 1.0,
        activeColor: Colors.red,
        inactiveColor: Colors.grey[300],
      ),
          Text(
            _formatDuration(_totalDuration),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: _toggleFullScreen,
          ),
        ],
      ),
    );
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && 
          _controller != null && 
          _controller!.value.isInitialized && 
          _controller!.value.isPlaying && 
          _showControls) {
        setState(() => _showControls = false);
      }
    });
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String episodeTitle;
  final Function onExitFullScreen;

  const FullScreenVideoPlayer({
    Key? key,
    required this.controller,
    required this.episodeTitle,
    required this.onExitFullScreen,
  }) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _showControls = true;
  Timer? _hideControlsTimer;
  Duration _playbackPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _playbackPosition = widget.controller.value.position;
    _totalDuration = widget.controller.value.duration;
    
    // Listen to controller updates
    widget.controller.addListener(_updateState);
    
    _startHideControlsTimer();
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _playbackPosition = widget.controller.value.position;
        _totalDuration = widget.controller.value.duration;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (widget.controller.value.isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
      _showControls = true;
    });
    _startHideControlsTimer();
  }

  void _toggleControlsVisibility() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideControlsTimer();
  }

  void _seekToPosition(double value) {
    final position = value * _totalDuration.inMilliseconds;
    widget.controller.seekTo(Duration(milliseconds: position.toInt()));

    setState(() {
      _playbackPosition = Duration(milliseconds: position.toInt());
      _showControls = true;
    });
    _startHideControlsTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          widget.onExitFullScreen();
          return true;
        },
        child: GestureDetector(
          onTap: _toggleControlsVisibility,
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: VideoPlayer(widget.controller),
                ),
              ),
              if (_showControls) _buildFullScreenControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                widget.onExitFullScreen();
                Navigator.pop(context);
              },
            ),
            title: Text(
              widget.episodeTitle,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Center(
              child: IconButton(
                icon: Icon(
                  widget.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 50,
                  color: Colors.white,
                ),
                onPressed: _togglePlayPause,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 8.0),
            child: Column(
              children: [
                Slider(
                  value: _totalDuration.inMilliseconds > 0
                      ? _playbackPosition.inMilliseconds / _totalDuration.inMilliseconds
                      : 0.0,
                  onChanged: _seekToPosition,
                  onChangeStart: (_) => _hideControlsTimer?.cancel(),
                  onChangeEnd: (_) => _startHideControlsTimer(),
                  min: 0.0,
                  max: 1.0,
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey[300],
                ),
                Row(
                  children: [
                    Text(
                      _formatDuration(_playbackPosition),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      _formatDuration(_totalDuration),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}