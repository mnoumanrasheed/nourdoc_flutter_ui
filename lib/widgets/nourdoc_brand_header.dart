import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class NourDocBrandHeader extends StatelessWidget {
  const NourDocBrandHeader({required this.step, required this.onBack, super.key});

  final int step;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topCenter,
    children: [
      const Positioned(
        top: 64,
        right: 34,
        child: Icon(Icons.add_rounded, size: 28, color: Color(0x12286252)),
      ),
      const Positioned(
        top: 68,
        left: 24,
        child: SizedBox(
          width: 56,
          height: 42,
          child: CustomPaint(painter: _MedicalCurvePainter()),
        ),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.brand,
                    tooltip: step == 1 ? null : 'Back',
                  ),
                  const Spacer(),
                  Text(
                    'Step $step of 3',
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 82,
                height: 70,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0x14286252), Color(0x00286252)],
                  ),
                ),
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 60,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'NourDoc',
            style: TextStyle(
              fontSize: 27,
              height: 1,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Empowering Doctors with AI',
            style: TextStyle(fontSize: 12.5, color: AppColors.brand),
          ),
        ],
      ),
    ],
  );
}

class _MedicalCurvePainter extends CustomPainter {
  const _MedicalCurvePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x14286252)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(2, size.height * .2)
      ..cubicTo(
        size.width * .28,
        size.height * .05,
        size.width * .28,
        size.height * .88,
        size.width * .62,
        size.height * .75,
      )
      ..cubicTo(
        size.width * .82,
        size.height * .68,
        size.width * .82,
        size.height * .4,
        size.width - 2,
        size.height * .42,
      );
    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(size.width - 3, size.height * .42), 3.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
