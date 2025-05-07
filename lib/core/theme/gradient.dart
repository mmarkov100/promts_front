import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final List<Color> colors;
  final Widget child;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.colors,
    required this.child,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentBegin;
  late Animation<Alignment> _alignmentEnd;
  late List<Color> _colors;
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _colors = widget.colors;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          setState(() {
            _colorIndex = (_colorIndex + 1) % _colors.length;
          });
          _controller.forward();
        }
      });

    _alignmentBegin = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(_controller);

    _alignmentEnd = Tween<Alignment>(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor(int offset) {
    return _colors[(_colorIndex + offset) % _colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _alignmentBegin.value,
              end: _alignmentEnd.value,
              colors: [
                Color.lerp(_getColor(0), _getColor(1), _controller.value)!,
                Color.lerp(_getColor(1), _getColor(2), _controller.value)!,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
