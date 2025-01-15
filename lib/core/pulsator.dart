import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';

class Pulsator extends StatefulWidget {
  const Pulsator({
    Key? key,
    required this.title,
    this.size = 24.0,
    this.color = Colors.blue,
    this.duration = const Duration(seconds: 2),
    this.rippleCount = 1, // Number of simultaneous ripples
  }) : super(key: key);

  final String title;
  final double size; // Size of the circle
  final Color color; // Color of the ripple
  final Duration duration; // Duration of the ripple animation
  final int rippleCount; // Number of ripple circles

  @override
  State<Pulsator> createState() => _PulsatorState();
}

class _PulsatorState extends State<Pulsator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(); // Repeat infinitely
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...List.generate(widget.rippleCount, (index) {
                final delay =
                    widget.rippleCount > 0 ? index / widget.rippleCount : 0;
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double progress = (_controller.value + delay) % 1.0;
                    double scale = 1.0 + progress * 10; // Controls expansion
                    double opacity = 1.0 - progress; // Fades out

                    return Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 6.0,
        ),
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: CustomStyle.sizeL,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
