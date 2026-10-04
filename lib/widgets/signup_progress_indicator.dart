import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SignupProgressIndicator extends StatelessWidget {
  const SignupProgressIndicator({required this.currentStep, super.key});
  final int currentStep;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: List.generate(5, (index) {
          if (index.isOdd) {
            final complete = currentStep > (index + 1) ~/ 2;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                color: complete ? AppColors.brand : AppColors.inactive,
              ),
            );
          }
          final step = index ~/ 2 + 1;
          final complete = step < currentStep;
          final current = step == currentStep;
          return AnimatedScale(
            scale: current ? 1.1 : 1,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: complete || current ? AppColors.brand : Colors.white,
                border: Border.all(
                  color: complete || current
                      ? AppColors.brand
                      : AppColors.inactive,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: complete
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 19,
                    )
                  : Center(
                      child: Text(
                        '$step',
                        style: TextStyle(
                          color: current ? Colors.white : AppColors.mutedText,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          );
        }),
      ),
      const SizedBox(height: 6),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Personal',
            style: TextStyle(fontSize: 12, color: AppColors.mutedText),
          ),
          Text(
            'Professional',
            style: TextStyle(fontSize: 12, color: AppColors.mutedText),
          ),
          Text(
            'License',
            style: TextStyle(fontSize: 12, color: AppColors.mutedText),
          ),
        ],
      ),
    ],
  );
}
