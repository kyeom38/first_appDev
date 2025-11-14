import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';

/// 온보딩 다음 버튼
class OnboardingNextButton extends StatelessWidget {
  /// [OnboardingNextButton] 생성자
  const OnboardingNextButton({
    required this.onPressed,
    this.isEnabled = true,
    this.label = '다음',
    super.key,
  });

  /// 버튼 클릭 핸들러
  final VoidCallback onPressed;

  /// 활성화 여부
  final bool isEnabled;

  /// 버튼 텍스트
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          disabledBackgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: AppTypography.title.copyWith(
            color: isEnabled ? Colors.white : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
