import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../fitness/controllers/fitness_controller.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_next_button.dart';

/// 온보딩 4단계 - 목표 설정 화면
class OnboardingStep4Screen extends ConsumerStatefulWidget {
  /// [OnboardingStep4Screen] 생성자
  const OnboardingStep4Screen({super.key});

  @override
  ConsumerState<OnboardingStep4Screen> createState() =>
      _OnboardingStep4ScreenState();
}

class _OnboardingStep4ScreenState extends ConsumerState<OnboardingStep4Screen> {
  final _startWeightController = TextEditingController();
  final _goalWeightController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // 온보딩 데이터에서 현재 체중을 시작 몸무게로 자동 입력
    final onboardingData = ref.read(onboardingProvider);
    if (onboardingData.weight != null) {
      _startWeightController.text = onboardingData.weight!.toString();
    }
  }

  @override
  void dispose() {
    _startWeightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final colors = Theme.of(context).extension<AppColors>()!;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveGoalAndComplete() {
    final startWeight = double.tryParse(_startWeightController.text);
    final goalWeight = double.tryParse(_goalWeightController.text);

    if (startWeight == null || goalWeight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('몸무게를 올바르게 입력해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('목표 기간을 선택해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 목표 저장
    ref
        .read(fitnessControllerProvider.notifier)
        .setGoal(
          startWeight: startWeight,
          goalWeight: goalWeight,
          targetDate: _selectedDate!,
        );

    // 온보딩 완료 - 메인 화면으로 이동
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('온보딩이 완료되었습니다!'),
        backgroundColor: Theme.of(context).extension<AppColors>()!.primary,
      ),
    );

    // 온보딩 데이터 초기화
    ref.read(onboardingProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isValid =
        _startWeightController.text.isNotEmpty &&
        _goalWeightController.text.isNotEmpty &&
        _selectedDate != null;

    return Scaffold(
      backgroundColor: Colors.white,
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
                      '마지막으로,\n목표를 설정해주세요!',
                      style: AppTypography.heading.copyWith(
                        color: colors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '설정한 목표에 맞춰 맞춤형 식단을 추천해드립니다',
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildStartWeightField(colors),
                    const SizedBox(height: 16),
                    _buildGoalWeightField(colors),
                    const SizedBox(height: 16),
                    _buildGoalDateField(colors),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: OnboardingNextButton(
                onPressed: _saveGoalAndComplete,
                isEnabled: isValid,
                label: '완료',
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
            color: index == 3
                ? colors.primary
                : colors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildStartWeightField(AppColors colors) {
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
            'fitness.start_weight'.tr(),
            style: AppTypography.body.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _startWeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'fitness.enter_start_weight'.tr(),
              hintStyle: AppTypography.body.copyWith(
                color: colors.textSecondary,
              ),
              suffixText: 'kg',
              suffixStyle: AppTypography.body.copyWith(
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

  Widget _buildGoalWeightField(AppColors colors) {
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
            'fitness.goal_weight'.tr(),
            style: AppTypography.body.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _goalWeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'fitness.enter_goal_weight'.tr(),
              hintStyle: AppTypography.body.copyWith(
                color: colors.textSecondary,
              ),
              suffixText: 'kg',
              suffixStyle: AppTypography.body.copyWith(
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

  Widget _buildGoalDateField(AppColors colors) {
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
            'fitness.goal_period'.tr(),
            style: AppTypography.body.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'fitness.when_to_achieve'.tr()
                        : DateFormat('yyyy년 MM월 dd일').format(_selectedDate!),
                    style: AppTypography.body.copyWith(
                      color: _selectedDate == null
                          ? colors.textSecondary
                          : colors.textPrimary,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
