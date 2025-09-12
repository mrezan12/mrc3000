import 'dart:math' as math;
import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({
    super.key,
    required this.front,
    required this.back,
    required this.flipped,
    this.onTap,
  });

  final Widget front;
  final Widget back;
  final bool flipped;
  final VoidCallback? onTap;

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void didUpdateWidget(covariant Flashcard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flipped != oldWidget.flipped) {
      widget.flipped ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final angle = _controller.value * math.pi;
          final isUnder = angle > math.pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: isUnder ? 0.0 : 1.0,
                  child: _CardShell(child: widget.front),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: Opacity(
                    opacity: isUnder ? 1.0 : 0.0,
                    child: _CardShell(child: widget.back),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Material(
        color: scheme.surface,
        elevation: 2,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: child),
        ),
      ),
    );
  }
}
