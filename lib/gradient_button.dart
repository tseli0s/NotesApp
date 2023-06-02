import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double size;
  final List<Color>? iconGradientColors;

  const GradientButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.gradientColors,
    this.size = 32.0,
    this.iconGradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: iconGradientColors ?? gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: icon,
        ),
      ),
    );
  }
}
