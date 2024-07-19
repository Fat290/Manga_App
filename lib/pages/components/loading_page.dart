import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _colorTween = ColorTween(begin: Colors.white, end: Colors.red)
        .animate(_controller);

    _controller.repeat(reverse: true);


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.9),
                    Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
                  ],
                  stops: [
                    _controller.value - 0.3,
                    _controller.value,
                    _controller.value + 0.3,
                  ],
                ).createShader(rect);
              },
              child: const Text(
                'MangaVerse',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // This color will be overridden by the ShaderMask
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}