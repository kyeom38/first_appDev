import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';

/// 온보딩 프로그레스 바
class OnboardingProgressBar extends StatelessWidget {
  /// [OnboardingProgressBar] 생성자
  const OnboardingProgressBar({
    required this.currentStep,
    required this.totalSteps,
    super.key,
  });

  /// 현재 단계
  final int currentStep;

  /// 전체 단계 수
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: List.generate(
        totalSteps,
        (index) => Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(
              right: index < totalSteps - 1 ? 8 : 0,
            ),
            decoration: BoxDecoration(
              color: index < currentStep
                  ? colors.primary
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
