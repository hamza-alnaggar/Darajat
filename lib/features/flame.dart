import 'dart:math';

import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C1B3A),
              Color(0xFF1D2C4D),
              Color(0xFF2A3A5F),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white70),
                    onPressed: () {},
                  ),
                  const Text(
                    'Flame of Enthusiasm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -20 * (1 - _flameAnimation.value)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Flame Container with Particles
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Floating particles
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
                              // Animated Flame
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
                          const SizedBox(height: 40),
                          // Streak Counter
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Current Streak',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${widget.currentStreak}',
                                    style: const TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFeatures: [FontFeature.tabularFigures()],
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
                          const SizedBox(height: 40),
                          // Motivational text
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMotivationalText(int streak) {
    if (streak < 7) return 'Keep going! The fire is just starting to burn!';
    if (streak < 21) return 'Great consistency! Your flame is growing brighter!';
    if (streak < 50) return 'Amazing dedication! Your enthusiasm is shining!';
    return 'Incredible perseverance! Your fire inspires others!';
  }
}