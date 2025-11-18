import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Skeleton extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const Skeleton({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: borderRadius,
      ),
    ).animate(onPlay: (c) => c.repeat())
        .fadeIn(duration: const Duration(milliseconds: 1200))
        .fadeOut(begin: 1, end: 0.3);
  }
}
