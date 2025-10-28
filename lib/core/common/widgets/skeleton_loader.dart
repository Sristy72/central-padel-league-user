import 'package:flutter/material.dart';

/// A reusable skeleton loader widget for displaying loading states
/// across the app. Provides a professional shimmer-like effect.
class SkeletonLoader extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonLoader({
    super.key,
    required this.height,
    this.width,
    this.borderRadius,
    this.margin,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
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
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey[800]!,
                Colors.grey[700]!,
                Colors.grey[800]!,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton loader for card-like items (e.g., league cards, team cards)
class SkeletonCard extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;

  const SkeletonCard({
    super.key,
    this.height = 120,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonLoader(
                height: 60,
                width: 60,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                      height: 20,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    SkeletonLoader(
                      height: 16,
                      width: 150,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for list items
class SkeletonListItem extends StatelessWidget {
  final int itemCount;

  const SkeletonListItem({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}

/// Skeleton loader for the home screen sections
class HomeSkeletonLoader extends StatelessWidget {
  const HomeSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game Reminder section
          const SkeletonLoader(height: 24, width: 150),
          const SizedBox(height: 12),
          const SkeletonLoader(height: 90, width: double.infinity),
          const SizedBox(height: 20),

          // League Update section
          const SkeletonLoader(height: 24, width: 140),
          const SizedBox(height: 12),
          const SkeletonLoader(height: 100, width: double.infinity),
          const SizedBox(height: 20),

          // Next Match section
          const SkeletonLoader(height: 24, width: 120),
          const SizedBox(height: 12),
          const SkeletonLoader(height: 180, width: double.infinity),
          const SizedBox(height: 20),

          // Quick Stats section
          const SkeletonLoader(height: 24, width: 110),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SkeletonLoader(
                  height: 80,
                  width: double.infinity,
                  margin: const EdgeInsets.only(right: 8),
                ),
              ),
              Expanded(
                child: SkeletonLoader(
                  height: 80,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Fixtures section
          const SkeletonLoader(height: 24, width: 100),
          const SizedBox(height: 12),
          const SkeletonLoader(height: 120, width: double.infinity),
          const SizedBox(height: 12),
          const SkeletonLoader(height: 120, width: double.infinity),
        ],
      ),
    );
  }
}

/// Skeleton loader for league details tabs (standings/fixtures)
class LeagueDetailsSkeletonLoader extends StatelessWidget {
  const LeagueDetailsSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                SkeletonLoader(
                  height: 40,
                  width: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(
                        height: 16,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 6),
                      SkeletonLoader(
                        height: 12,
                        width: 120,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton loader for team details screen
class TeamDetailsSkeletonLoader extends StatelessWidget {
  const TeamDetailsSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Team logo
          SkeletonLoader(
            height: 100,
            width: 100,
            borderRadius: BorderRadius.circular(50),
          ),
          const SizedBox(height: 16),

          // Team name
          const SkeletonLoader(height: 24, width: 180),
          const SizedBox(height: 8),

          // Team info
          const SkeletonLoader(height: 16, width: 150),
          const SizedBox(height: 24),

          // Divider
          const SkeletonLoader(height: 1, width: double.infinity),
          const SizedBox(height: 24),

          // Team members section
          const SkeletonLoader(height: 20, width: 140),
          const SizedBox(height: 16),

          // Member cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SkeletonLoader(
                      height: 80,
                      width: 80,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    const SizedBox(height: 8),
                    const SkeletonLoader(height: 16, width: 100),
                    const SizedBox(height: 4),
                    const SkeletonLoader(height: 12, width: 80),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    SkeletonLoader(
                      height: 80,
                      width: 80,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    const SizedBox(height: 8),
                    const SkeletonLoader(height: 16, width: 100),
                    const SizedBox(height: 4),
                    const SkeletonLoader(height: 12, width: 80),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/// Skeleton loader for profile screen
class ProfileSkeletonLoader extends StatelessWidget {
  const ProfileSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SkeletonLoader(
            height: 100,
            width: 100,
            borderRadius: BorderRadius.circular(50),
          ),
          const SizedBox(height: 14),
          const SkeletonLoader(height: 20, width: 150),
          const SizedBox(height: 19),
          Row(
            children: [
              const Spacer(),
              SkeletonLoader(
                height: 40,
                width: 120,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          const SizedBox(height: 33),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Column(
              children: [
                SkeletonLoader(height: 16, width: double.infinity),
                SizedBox(height: 24),
                SkeletonLoader(height: 16, width: double.infinity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
