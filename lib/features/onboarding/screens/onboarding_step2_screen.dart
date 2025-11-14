import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../controllers/onboarding_controller.dart';
import '../models/onboarding_data.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_next_button.dart';

/// 온보딩 2단계 - 목적 선택 화면
class OnboardingStep2Screen extends ConsumerWidget {
  /// [OnboardingStep2Screen] 생성자
  const OnboardingStep2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final data = ref.watch(onboardingProvider);
    final controller = ref.read(onboardingProvider.notifier);
    final isValid = controller.validateStep2();

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2/5',
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const OnboardingProgressBar(
                    currentStep: 2,
                    totalSteps: 5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '멋진 변화의 시작,\n목표를 알려주세요!',
                      style: AppTypography.heading.copyWith(
                        color: colors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '다이어트의 주된 목적이 무엇인가요?\n(복수 선택 가능)',
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildPurposeGrid(context, colors, data, controller),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: OnboardingNextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding/step3');
                },
                isEnabled: isValid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurposeGrid(
    BuildContext context,
    AppColors colors,
    OnboardingData data,
    OnboardingController controller,
  ) {
    final purposes = DietPurpose.values;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // 첫 줄: 근육량 증가, 체중 감량
        Row(
          children: [
            Expanded(
              child: _buildPurposeCard(
                colors,
                purposes[0],
                data.purposes.contains(purposes[0]),
                controller,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPurposeCard(
                colors,
                purposes[1],
                data.purposes.contains(purposes[1]),
                controller,
              ),
            ),
          ],
        ),
        // 둘째 줄: 체형 유지, 건강 개선
        Row(
          children: [
            Expanded(
              child: _buildPurposeCard(
                colors,
                purposes[2],
                data.purposes.contains(purposes[2]),
                controller,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPurposeCard(
                colors,
                purposes[3],
                data.purposes.contains(purposes[3]),
                controller,
              ),
            ),
          ],
        ),
        // 셋째 줄: 식습관 개선
        SizedBox(
          width: (MediaQuery.of(context).size.width - 72) / 2,
          child: _buildPurposeCard(
            colors,
            purposes[4],
            data.purposes.contains(purposes[4]),
            controller,
          ),
        ),
      ],
    );
  }

  Widget _buildPurposeCard(
    AppColors colors,
    DietPurpose purpose,
    bool isSelected,
    OnboardingController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.togglePurpose(purpose),
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? colors.primary : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getPurposeIconColor(purpose).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  purpose.icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              purpose.displayName,
              style: AppTypography.body.copyWith(
                color: colors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPurposeIconColor(DietPurpose purpose) {
    switch (purpose) {
      case DietPurpose.muscleGain:
        return const Color(0xFF64B5F6); // 파랑
      case DietPurpose.weightLoss:
        return const Color(0xFF4DD0E1); // 청록
      case DietPurpose.maintenance:
        return const Color(0xFFFF8A65); // 주황
      case DietPurpose.health:
        return const Color(0xFFEF5350); // 빨강
      case DietPurpose.nutrition:
        return const Color(0xFF66BB6A); // 초록
    }
  }
}
