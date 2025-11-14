import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../controllers/onboarding_controller.dart';
import '../models/onboarding_data.dart';
import '../widgets/onboarding_next_button.dart';

/// 온보딩 3단계 - 신체 정보 입력 화면
class OnboardingStep3Screen extends ConsumerStatefulWidget {
  /// [OnboardingStep3Screen] 생성자
  const OnboardingStep3Screen({super.key});

  @override
  ConsumerState<OnboardingStep3Screen> createState() =>
      _OnboardingStep3ScreenState();
}

class _OnboardingStep3ScreenState extends ConsumerState<OnboardingStep3Screen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingProvider);
    _heightController.text = data.height?.toString() ?? '';
    _weightController.text = data.weight?.toString() ?? '';
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final data = ref.watch(onboardingProvider);
    final controller = ref.read(onboardingProvider.notifier);
    final isValid = controller.validateStep3();

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildPageIndicator(colors),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '정확한 분석을 위해\n신체 정보를 알려주세요!',
                      style: AppTypography.heading.copyWith(
                        color: colors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildHeightSection(colors, controller),
                    const SizedBox(height: 16),
                    _buildWeightSection(colors, controller),
                    const SizedBox(height: 24),
                    if (data.bmi != null) _buildBmiCard(colors, data),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: OnboardingNextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding/step4');
                },
                isEnabled: isValid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(AppColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 2 ? colors.primary : colors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildHeightSection(AppColors colors, OnboardingController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '키 (cm)',
            style: AppTypography.body.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (value) {
              final height = double.tryParse(value);
              if (height != null) {
                controller.updateHeight(height);
              }
            },
            decoration: InputDecoration(
              hintText: '키를 입력하세요',
              hintStyle: AppTypography.body.copyWith(
                color: colors.textSecondary,
              ),
              filled: true,
              fillColor: colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            style: AppTypography.body.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightSection(AppColors colors, OnboardingController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '현재 체중 (kg)',
            style: AppTypography.body.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (value) {
              final weight = double.tryParse(value);
              if (weight != null) {
                controller.updateWeight(weight);
              }
            },
            decoration: InputDecoration(
              hintText: '현재 체중을 입력하세요',
              hintStyle: AppTypography.body.copyWith(
                color: colors.textSecondary,
              ),
              filled: true,
              fillColor: colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            style: AppTypography.body.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildBmiCard(AppColors colors, OnboardingData data) {
    final bmi = data.bmi!;
    final bmr = data.bmr;

    String bmiStatus;
    if (bmi < 18.5) {
      bmiStatus = '저체중';
    } else if (bmi < 23) {
      bmiStatus = '정상';
    } else if (bmi < 25) {
      bmiStatus = '과체중';
    } else {
      bmiStatus = '비만';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BMI',
                style: AppTypography.title.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '${bmi.toStringAsFixed(1)} ($bmiStatus)',
                style: AppTypography.title.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (bmr != null) ...[
            const SizedBox(height: 16),
            Text(
              '회원님의 하루 기초대사량은\n약 ${bmr.toStringAsFixed(0)} kcal 입니다.',
              style: AppTypography.body.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
