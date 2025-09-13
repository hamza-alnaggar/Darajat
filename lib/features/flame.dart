import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
import 'package:learning_management_system/features/statistics/data/models/statistics_item_model.dart';
import 'package:learning_management_system/features/statistics/data/repositories/statistics_repository.dart';
import 'package:learning_management_system/features/statistics/presentation/cubit/statistics_cubit.dart';
import 'package:learning_management_system/features/statistics/presentation/cubit/statistics_state.dart';
import 'package:learning_management_system/generated/l10n.dart';
import 'package:lottie/lottie.dart';

class FlameOfEnthusiasmPage extends StatelessWidget {
  const FlameOfEnthusiasmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsCubit(repository: sl<StatisticsRepository>())..getStatistics(true),
      child: const _FlameOfEnthusiasmScaffold(),
    );
  }
}

class _FlameOfEnthusiasmScaffold extends StatelessWidget {
  const _FlameOfEnthusiasmScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).flame),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsInitial || state is StatisticsLoading) {
              return Center(child: Lottie.asset('assets/images/loading.json'));
            }

            if (state is StatisticsFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.errMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<StatisticsCubit>().getStatistics(true),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is StatisticsSuccess) {
              final stats = state.statistics;

              int computedStreak = 0;
              StatisticsItemModel? streakItem;

              for (final s in stats) {
                final title = s.title.toLowerCase();
                if (title.contains('streak') ||
                    (title.contains('current') && (title.contains('day') || title.contains('days'))) ||
                    title.contains('consecutive')) {
                  streakItem = s;
                  break;
                }
              }
              if (streakItem != null) {
                computedStreak = streakItem.progress;
              } else if (stats.isNotEmpty) {
                computedStreak = stats.map((s) => s.progress).reduce(max);
              }

              return _FlameWithStatsBody(
                currentStreak: computedStreak,
                statistics: stats,
                onRefresh: () => context.read<StatisticsCubit>().getStatistics(true),
              );
            }
            // Fallback
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _FlameWithStatsBody extends StatelessWidget {
  final int currentStreak;
  final List<StatisticsItemModel> statistics;
  final VoidCallback onRefresh;

  const _FlameWithStatsBody({
    Key? key,
    required this.currentStreak,
    required this.statistics,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
           CustomColors.backgroundColor,
           CustomColors.secondary
          //  Color(0xFF2A3A5F),
          ],
        ),
      ),
      child: Column(
        children: [
        
          const SizedBox(height: 6),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  FlameOfEnthusiasm(currentStreak: currentStreak),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Your Statistics', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        _StatisticTile(item: statistics.last,),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticTile extends StatelessWidget {
  final StatisticsItemModel item;

  const _StatisticTile({Key? key, required this.item,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Card(
        color: CustomColors.backgroundColor,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Colors.orange.shade200, Colors.deepOrange.shade400]),
                  boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.25), blurRadius: 8, spreadRadius: 2)],
                ),
                child: const Icon(Icons.whatshot, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    // show the raw value (no percentage) and an optional caption
                    Text('${item.progress}  •  Top Flame', style:  TextStyle(color: Colors.white70,fontSize: 18.r)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  
  }
}

class FlameOfEnthusiasm extends StatefulWidget {
  final int currentStreak;

  const FlameOfEnthusiasm({Key? key, required this.currentStreak}) : super(key: key);

  @override
  _FlameOfEnthusiasmState createState() => _FlameOfEnthusiasmState();
}

class _FlameOfEnthusiasmState extends State<FlameOfEnthusiasm> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flameAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _flameAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 50),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _pulseAnimation = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -20 * (1 - _flameAnimation.value)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ...List.generate(8, (index) {
                    final angle = 2 * pi * index / 8;
                    final distance = 40.0;
                    return Transform.translate(
                      offset: Offset(
                        cos(angle + _controller.value * pi * 2) * distance,
                        sin(angle + _controller.value * pi * 2) * distance,
                      ),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                  Transform.scale(
                    scale: _flameAnimation.value,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.orange.shade400,
                            Colors.red,
                            Colors.deepOrange,
                          ],
                          stops: const [0.1, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.whatshot,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                       Text(
                        'Current Streak',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.orange.shade200,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.currentStreak}',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Days',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.orange.shade200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  _getMotivationalText(widget.currentStreak),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMotivationalText(int streak) {
    if (streak < 7) return 'Keep going! The fire is just starting to burn!';
    if (streak < 21) return 'Great consistency! Your flame is growing brighter!';
    if (streak < 50) return 'Amazing dedication! Your enthusiasm is shining!';
    return 'Incredible perseverance! Your fire inspires others!';
  }
}
