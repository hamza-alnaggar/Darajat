// lib/features/statistics/presentation/pages/statistics_page.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
import 'package:learning_management_system/features/statistics/data/models/statistics_item_model.dart';
import 'package:learning_management_system/features/statistics/presentation/cubit/statistics_cubit.dart';
import 'package:learning_management_system/features/statistics/presentation/cubit/statistics_state.dart';


class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Learning Statistics',

      ),
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StatisticsFailure) {
            return Center(child: Text('Error: ${state.errMessage}'));
          } else if (state is StatisticsSuccess) {
            return _StatisticsShell(statistics: state.statistics);
          }
          return const Center(child: Text('Load your statistics'));
        },
      ),
    );
  }
}

class _StatisticsShell extends StatefulWidget {
  final List<StatisticsItemModel> statistics;
  const _StatisticsShell({Key? key, required this.statistics})
    : super(key: key);

  @override
  State<_StatisticsShell> createState() => _StatisticsShellState();
}

class _StatisticsShellState extends State<_StatisticsShell>
    with SingleTickerProviderStateMixin {
  late List<StatisticsItemModel> stats;
  int _sortMode = 0; 

  @override
  void initState() {
    super.initState();
    stats = List.from(widget.statistics);
  }

  void _sortStats(int mode) {
    setState(() {
      _sortMode = mode;
      if (mode == 1) {
        stats.sort((a, b) => a.progress.compareTo(b.progress));
      } else if (mode == 2) {
        stats.sort((a, b) => b.progress.compareTo(a.progress));
      } else {
        stats = List.from(widget.statistics);
      }
    });
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF5B21B6), 
      const Color(0xFF0EA5E9), 
      const Color(0xFF16A34A), 
      const Color(0xFFF59E0B), 
      const Color(0xFFEF4444), 
    ];
    return colors[index % colors.length];
  }

  double get averageProgress {
    if (stats.isEmpty) return 0;
    final s = stats.fold<int>(0, (p, e) => p + e.progress);
    return s / stats.length;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
SizedBox(height: 10.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ToggleButtons(
                        isSelected: [
                          _sortMode == 0,
                          _sortMode == 1,
                          _sortMode == 2,
                        ],
                        onPressed: (i) => _sortStats(i),
                        borderRadius: BorderRadius.circular(8),
                        selectedBorderColor: Theme.of(context).primaryColor,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Default'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Lowest'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Highest'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Chart Card
                  Card(
                    color: CustomColors.secondary,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Progress Overview',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            children: List.generate(stats.length, (i) {
                              return _LegendChip(
                                color: _getColorForIndex(i),
                                label: stats[i].title,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Detailed Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // List inside the scroll view: keep shrinkWrap true and disable its scrolling
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stats.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = stats[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: _getColorForIndex(
                            index,
                          ).withOpacity(0.14),
                          child: Text(
                            '${item.progress}%',
                            style: TextStyle(
                              color: _getColorForIndex(index),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: LinearProgressIndicator(
                            value: (item.progress / 100).clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(
                              _getColorForIndex(index),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallProgressRing extends StatelessWidget {
  final double value;
  const _OverallProgressRing({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value / 100),
        duration: const Duration(milliseconds: 700),
        builder: (context, animatedValue, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: animatedValue.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(Colors.deepPurpleAccent),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(animatedValue * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'avg',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendChip({Key? key, required this.color, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: color.withOpacity(0.12),
      avatar: CircleAvatar(radius: 8, backgroundColor: color),
      label: Text(label, overflow: TextOverflow.ellipsis),
    );
  }
}
