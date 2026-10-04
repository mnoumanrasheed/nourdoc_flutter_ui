import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SignupHeroHeader extends StatelessWidget {
  const SignupHeroHeader({
    required this.step,
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.direction,
    this.onBack,
    super.key,
  });

  final int step;
  final String assetPath;
  final String title;
  final String subtitle;
  final int direction;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (onBack != null)
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.brand,
                  tooltip: 'Back',
                )
              else
                const SizedBox(width: 48),
              const Spacer(),
              Text(
                'Step $step of 3',
                style: const TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 155,
          width: double.infinity,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 260),
            transitionBuilder: (child, animation) {
              final offset =
                  Tween<Offset>(
                    begin: Offset(direction * .05, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offset, child: child),
              );
            },
            child: ClipRRect(
              key: ValueKey(assetPath),
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFF7FAF9),
                          Color(0xEAF7FAF9),
                          Color(0x55F7FAF9),
                          Color(0x00F7FAF9),
                        ],
                        stops: [0, .38, .65, 1],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 15, 18, 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                height: 28,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'NourDoc',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 27,
                              height: 1.08,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.mutedText,
                              fontSize: 13.5,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
