import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_state.dart';
import 'package:video_player/video_player.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class InlineVideoPlayer extends StatefulWidget {
  final EpisodeModel episode;
  final bool isStudent;
  final bool showExtraInfol;
  final bool isCopy;

  const InlineVideoPlayer({
    super.key,
    required this.episode,
    required this.isStudent,
    required this.showExtraInfol,
    required this.isCopy,
  });

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isLoading = false;
  EpisodeModel ?currentEpisode;
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
      await cubit.loadEpisodeMedia(widget.episode.id,true,widget.isCopy);
      final newStream = cubit.videoStream;
      setState(() {
        _currentVideoStream = newStream;
      });
      _initializePlayer(newStream!);
    } catch (e) {
      print("Error getting video stream: $e");
      // Handle error
    }
  }

  Future<void> _initializePlayer(Stream<Uint8List> videoStream) async {
    print(_isInitialized);
    if (_isInitialized || _isDisposed) return;
    setState(() {
      _isLoading = true;
      _isInitialized = true;
    });
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
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
        SnackBar(content: Text("فشل تهيئة الفيديو: ${e.toString()}"))
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
            
            _isPlaying = false;
            if(widget.showExtraInfol)
            _controller!.addListener(_checkVideoCompletion);
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
    
    // Update progress immediately
    context.read<EpisodeDetailCubit>().updateProgress(progress);

    print('progress!!!!!!!!!!!!!!!!!!!!!1 $progress');
    
    // Check completion on every position change
    if (progress >= 0.5) {
      print('okkkkkkkkkkkkkkkkkk');
      context.read<EpisodeDetailCubit>().checkCompletion(widget.episode.id);
    }
    if (position >= duration && duration > Duration.zero) {
    context.read<EpisodeDetailCubit>().updateProgress(1.0);
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
      _isPlaying = !_isPlaying;
      _showControls = true;
    });
    
    if (_isPlaying) {
      _controller!.play();
      _startHideControlsTimer();
    } else {
      _controller!.pause();
      _hideControlsTimer?.cancel();
    }
  }

  void _toggleFullScreen() {
    if (_controller == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: _buildFullScreenPlayer(),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildFullScreenPlayer() {
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(_controller!),
          _buildFullScreenControls(),
        ],
      ),
    );
  }

  Widget _buildFullScreenControls() {
    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
        if (_showControls) _startHideControlsTimer();
      },
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black38,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 60,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              ),
              _buildProgressBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            _formatDuration(_playbackPosition),
            style: const TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Slider(
              value: _totalDuration.inMilliseconds > 0
                  ? _playbackPosition.inMilliseconds / _totalDuration.inMilliseconds
                  : 0.0,
              onChanged: _seekToPosition,
              min: 0.0,
              max: 1.0,
              activeColor: Colors.red,
              inactiveColor: Colors.grey,
            ),
          ),
          Text(
            _formatDuration(_totalDuration),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
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



   Future<void> _disposePlayer() async {
    await _videoSubscription?.cancel();
    _videoSubscription = null;
    _controller?.dispose();
    _controller = null;
  }

  void _resetPlayer() {
    _isInitialized = false;
    _isLoading = false;
    _isPlaying = false;
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
        if(state is EpisodeDetailLoaded)
        setState(() {
          currentEpisode = state.episode;
        });
      },
      builder: (context, state) {
        final cubit = context.read<EpisodeDetailCubit>();
        if (cubit.videoStream != null ) {
         if (_currentVideoStream == null && !_isInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeNewStream();
          });
        }
        }
        return _buildPlayerUI(context,cubit.poster);
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
        if (state is EpisodeDetailError) {
          return Center(child: Text('errrrrror'),);
        }
        return _buildVideoContent(poster);
      },
    ),
  );
}

  Widget _buildVideoContent(Uint8List? poster) {
  return  Stack(
        fit: StackFit.expand,
        children: [
          if (_controller == null || !_controller!.value.isInitialized || !_isPlaying)
            poster !=null? Image.memory(
              poster,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                  ):_buildPlaceholder(),
          // الفيديو
          if (_controller != null && _controller!.value.isInitialized && _isPlaying)
            GestureDetector(
              onTap: () {
                setState(() => _showControls = true);
                _startHideControlsTimer();
              },
              child: VideoPlayer(_controller!),
            ),
          
          // عناصر التحكم
          if (_showControls && widget.showExtraInfol)
            _buildControlsOverlay(),
          
          // مؤشر التحميل
          if (_isLoading || _isBuffering)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
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
            // زر التشغيل/الإيقاف
            Positioned.fill(
              child: Center(
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 60,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
            ),
            
            // شريط التقدم
            if (_controller != null && _controller!.value.isInitialized)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: _buildProgressBar(),
              ),
            
            // الإحصائيات والأزرار
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // المشاهدات
                    _buildStatItem(
                      icon: Icons.remove_red_eye_outlined,
                      value: _formatNumber(currentEpisode!.views),
                      label: 'المشاهدات',
                    ),
                    
                    // الإعجابات
                    _buildLikeButton(context),
                    
                    // المدة
                    _buildStatItem(
                      icon: Icons.timer_outlined,
                      value: currentEpisode!.duration,
                      label: 'المدة',
                    ),
                    
                    // زر تكبير الشاشة
                    IconButton(
                      icon: const Icon(Icons.fullscreen, color: Colors.white),
                      onPressed: _toggleFullScreen,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildStatItem({required IconData icon, required String value, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600
            )),
            Text(label, style: const TextStyle(
              color: Colors.white70,
              fontSize: 12
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cubit = context.read<EpisodeDetailCubit>();
        cubit.toggleLike(
          currentEpisode!.id,
          currentEpisode!.isLiked ?? false,
        );
      },
      child: Row(
        children: [
          Icon(
            currentEpisode!.isLiked  ?? false 
                ? Icons.favorite 
                : Icons.favorite_border,
            size: 16,
            color: (currentEpisode!.isLiked  ?? false) 
                ? Colors.red 
                : Colors.white70,
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_formatNumber(currentEpisode!.likes )),
              const Text('الإعجابات', style: TextStyle(
                color: Colors.white70,
                fontSize: 12
              )),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }
}