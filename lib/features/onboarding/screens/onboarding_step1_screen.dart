import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../controllers/onboarding_controller.dart';
import '../models/onboarding_data.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_next_button.dart';

/// 온보딩 1단계 - 기본 정보 입력 화면
class OnboardingStep1Screen extends ConsumerStatefulWidget {
  /// [OnboardingStep1Screen] 생성자
  const OnboardingStep1Screen({super.key});

  @override
  ConsumerState<OnboardingStep1Screen> createState() =>
      _OnboardingStep1ScreenState();
}

class _OnboardingStep1ScreenState extends ConsumerState<OnboardingStep1Screen> {
  final _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingProvider);
    _nicknameController.text = data.nickname ?? '';
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final data = ref.watch(onboardingProvider);
    final controller = ref.read(onboardingProvider.notifier);
    final isValid = controller.validateStep1();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '목표 설정',
          style: AppTypography.title.copyWith(color: colors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const OnboardingProgressBar(
                currentStep: 1,
                totalSteps: 4,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '당신의\n목표를 알려주세요!',
                      style: AppTypography.heading.copyWith(
                        color: colors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildNicknameSection(colors, controller),
                    const SizedBox(height: 24),
                    _buildPasswordSection(colors, controller),
                    const SizedBox(height: 24),
                    _buildGenderSection(colors, data, controller),
                    const SizedBox(height: 24),
                    _buildBirthDateSection(colors, data, controller),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: OnboardingNextButton(
                onPressed: () {
                  // TODO: 다음 화면으로 이동
                  Navigator.pushNamed(context, '/onboarding/step2');
                },
                isEnabled: isValid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNicknameSection(
    AppColors colors,
    OnboardingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '닉네임',
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nicknameController,
            onChanged: controller.updateNickname,
            decoration: InputDecoration(
              hintText: '닉네임을 입력하세요',
              hintStyle: AppTypography.body.copyWith(
                color: colors.textSecondary,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
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

  Widget _buildPasswordSection(
    AppColors colors,
    OnboardingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '비밀번호 (선택)',
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            '앱 잠금을 원하시면 비밀번호를 설정하세요',
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true, // 비밀번호 숨김
            onChanged: controller.updatePassword,
            decoration: InputDecoration(
              hintText: '4자리 이상 입력하세요',
              hintStyle: AppTypography.body.copyWith(
                color: colors.textSecondary,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
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

  Widget _buildGenderSection(
    AppColors colors,
    OnboardingData data,
    OnboardingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '성별',
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton(
                  colors,
                  '남성',
                  Gender.male,
                  data.gender == Gender.male,
                  controller,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderButton(
                  colors,
                  '여성',
                  Gender.female,
                  data.gender == Gender.female,
                  controller,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(
    AppColors colors,
    String label,
    Gender gender,
    bool isSelected,
    OnboardingController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.updateGender(gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              color: isSelected ? colors.primary : colors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBirthDateSection(
    AppColors colors,
    OnboardingData data,
    OnboardingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '생년월일',
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000, 1, 1),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                controller.updateBirthDate(picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.birthDate == null
                        ? '생년월일을 선택하세요'
                        : '${data.birthDate!.year}년 ${data.birthDate!.month}월 ${data.birthDate!.day}일',
                    style: AppTypography.body.copyWith(
                      color: data.birthDate == null
                          ? colors.textSecondary
                          : colors.textPrimary,
                    ),
                  ),
                  Icon(Icons.calendar_today, color: colors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
