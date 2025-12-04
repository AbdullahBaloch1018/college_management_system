import 'package:flutter/material.dart';

/// Shimmer Effect Widgets
///
/// This file provides a collection of reusable shimmer loading effects.
/// Use these widgets to show loading states throughout your app.
///
/// Usage Examples:
///
/// 1. Basic shimmer container:
///    ```dart
///    ShimmerContainer(
///      width: 200,
///      height: 100,
///      borderRadius: 8,
///    )
///    ```
///
/// 2. Shimmer card list (for horizontal scrolling):
///    ```dart
///    ShimmerCardList(
///      itemCount: 3,
///      cardWidth: 320,
///      cardHeight: 240,
///    )
///    ```
///
/// 3. Shimmer list item:
///    ```dart
///    ShimmerListItem(
///      height: 80,
///      borderRadius: 12,
///    )
///    ```
///
/// 4. Custom shimmer with any widget:
///    ```dart
///    Shimmer(
///      child: YourCustomWidget(),
///    )
///    ```
///
/// 5. Complete homework section shimmer:
///    ```dart
///    ShimmerHomeworkSection(
///      cardCount: 2,
///    )
///    ```

/// Base shimmer widget that provides the shimmer animation effect
class Shimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0.0),
              end: Alignment(1.0 - _controller.value * 2, 0.0),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Shimmer effect for a rectangular container
class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer effect for a circular container
class ShimmerCircle extends StatelessWidget {
  final double diameter;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerCircle({
    super.key,
    required this.diameter,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Shimmer effect for a list item
class ShimmerListItem extends StatelessWidget {
  final double height;
  final double borderRadius;
  final EdgeInsets? padding;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerListItem({
    super.key,
    this.height = 80.0,
    this.borderRadius = 12.0,
    this.padding,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer(
        baseColor: baseColor ?? Colors.grey[300]!,
        highlightColor: highlightColor ?? Colors.grey[100]!,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

/// Shimmer effect for a card (like homework card)
class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsets? padding;
  final Color? baseColor;
  final Color? highlightColor;
  final bool showContent;

  const ShimmerCard({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16.0,
    this.padding,
    this.baseColor,
    this.highlightColor,
    this.showContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 16),
      child: Shimmer(
        baseColor: baseColor ?? Colors.grey[300]!,
        highlightColor: highlightColor ?? Colors.grey[100]!,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: showContent
              ? Padding(
                  padding: padding ?? const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerContainer(
                            width: double.infinity,
                            height: 20,
                            borderRadius: 4,
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[200],
                          ),
                          const SizedBox(height: 12),
                          ShimmerContainer(
                            width: double.infinity,
                            height: 16,
                            borderRadius: 4,
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[200],
                          ),
                          const SizedBox(height: 8),
                          ShimmerContainer(
                            width: 150,
                            height: 16,
                            borderRadius: 4,
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[200],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ShimmerContainer(
                        width: double.infinity,
                        height: 50,
                        borderRadius: 10,
                        baseColor: Colors.grey[400],
                        highlightColor: Colors.grey[200],
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Shimmer effect for a horizontal list of cards
class ShimmerCardList extends StatelessWidget {
  final int itemCount;
  final double cardWidth;
  final double cardHeight;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerCardList({
    super.key,
    this.itemCount = 3,
    this.cardWidth = 320,
    this.cardHeight = 240,
    this.borderRadius = 16.0,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return ShimmerCard(
            width: cardWidth,
            height: cardHeight,
            borderRadius: borderRadius,
            baseColor: baseColor,
            highlightColor: highlightColor,
          );
        },
      ),
    );
  }
}

/// Shimmer effect for a subject header with count badge
class ShimmerSubjectHeader extends StatelessWidget {
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerSubjectHeader({super.key, this.baseColor, this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          ShimmerContainer(
            width: 4,
            height: 24,
            borderRadius: 2,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
          const SizedBox(width: 12),
          ShimmerContainer(
            width: 150,
            height: 24,
            borderRadius: 4,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
          const Spacer(),
          ShimmerContainer(
            width: 30,
            height: 24,
            borderRadius: 20,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
        ],
      ),
    );
  }
}

/// Shimmer effect for homework list section
class ShimmerHomeworkSection extends StatelessWidget {
  final int cardCount;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerHomeworkSection({
    super.key,
    this.cardCount = 2,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerSubjectHeader(
          baseColor: baseColor,
          highlightColor: highlightColor,
        ),
        ShimmerCardList(
          itemCount: cardCount,
          baseColor: baseColor,
          highlightColor: highlightColor,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Shimmer effect for chart view with statistics cards
class ShimmerChartView extends StatelessWidget {
  final Color? baseColor;
  final Color? highlightColor;
  final double chartHeight;
  final int statCardCount;

  const ShimmerChartView({
    super.key,
    this.baseColor,
    this.highlightColor,
    this.chartHeight = 350,
    this.statCardCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Shimmer for chart
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShimmerContainer(
              width: double.infinity,
              height: chartHeight,
              borderRadius: 20,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
          ),
          // Shimmer for stat cards (2x2 grid)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // First row of stat cards
                Row(
                  children: [
                    Expanded(
                      child: ShimmerContainer(
                        width: double.infinity,
                        height: 100,
                        borderRadius: 16,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShimmerContainer(
                        width: double.infinity,
                        height: 100,
                        borderRadius: 16,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                    ),
                  ],
                ),
                // Second row of stat cards (if needed)
                if (statCardCount > 2) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ShimmerContainer(
                          width: double.infinity,
                          height: 100,
                          borderRadius: 16,
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ShimmerContainer(
                          width: double.infinity,
                          height: 100,
                          borderRadius: 16,
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}