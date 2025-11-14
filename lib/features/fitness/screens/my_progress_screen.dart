import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../diary/screens/diary_list_screen.dart';
import '../../routine/screens/routine_screen.dart';
import '../controllers/fitness_controller.dart';
import '../widgets/circular_progress_widget.dart';
import '../widgets/log_item_widget.dart';
import 'goal_setting_screen.dart';
import 'history_screen.dart';
import 'record_entry_screen.dart';

/// My Progress 메인 화면
class MyProgressScreen extends ConsumerWidget {
  /// [MyProgressScreen] 생성자
  const MyProgressScreen({super.key});

  /// 액션 선택 바텀시트 표시
  static void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 목표 설정 버튼
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoalSettingScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF9447),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flag_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'fitness.goal_setting'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1F36),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 기록 하기 버튼
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecordEntryScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF9447),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'fitness.record'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1F36),
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(fitnessControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF4A5568),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'fitness.my_progress'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1F36),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF1A1F36),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: progress.startWeight == 0 && progress.goalWeight == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 80,
                    color: const Color(0xFF8F9BB3).withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '목표를 설정해주세요',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1F36).withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '하단의 + 버튼을 눌러\n목표 설정을 시작하세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8F9BB3).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // D-day 표시
                  if (progress.dDayString != null)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9447).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          progress.dDayString!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9447),
                          ),
                        ),
                      ),
                    ),
                  if (progress.dDayString != null) const SizedBox(height: 16),

                  // 원형 진행률
                  Center(
                    child: CircularProgressWidget(
                      percentage: progress.progressPercentage,
                      size: 200,
                      strokeWidth: 16,
                      color: const Color(0xFFFF9447),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 몸무게 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _WeightInfo(
                        label: 'fitness.start'.tr(),
                        value: '${progress.startWeight.toStringAsFixed(0)} kg',
                        color: const Color(0xFF8F9BB3),
                      ),
                      _WeightInfo(
                        label: 'fitness.current'.tr(),
                        value:
                            '${progress.currentWeight.toStringAsFixed(1)} kg',
                        color: const Color(0xFF1A1F36),
                      ),
                      _WeightInfo(
                        label: 'fitness.goal'.tr(),
                        value: '${progress.goalWeight.toStringAsFixed(0)} kg',
                        color: const Color(0xFFFF9447),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 최근 활동 요약
                  Text(
                    '오늘의 기록',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 최근 몸무게 기록
                  if (progress.latestWeightLog != null)
                    LogItemWidget(log: progress.latestWeightLog!),

                  // 총 칼로리 소모량
                  if (progress.totalCaloriesBurned > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4CC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.local_fire_department_outlined,
                              color: Color(0xFFFF9447),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '총 ${progress.totalCaloriesBurned} 칼로리 소모',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1F36),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '오늘 운동량',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF8F9BB3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '오늘',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8F9BB3),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 총 칼로리 섭취량
                  if (progress.totalCaloriesIntake > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4CC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.restaurant_outlined,
                              color: Color(0xFFFF9447),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '총 ${progress.totalCaloriesIntake} 칼로리 섭취',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1F36),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '오늘 섭취량',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF8F9BB3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '오늘',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8F9BB3),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 최근 목표 달성
                  if (progress.latestGoalLog != null)
                    LogItemWidget(log: progress.latestGoalLog!),
                ],
              ),
            ),

      // 하단 네비게이션 바
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  label: 'fitness.home'.tr(),
                  isActive: true,
                  onTap: () {},
                ),
                _NavItem(
                  icon: Icons.history_outlined,
                  label: 'fitness.history'.tr(),
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                  },
                ),
                _FloatingActionButtonItem(
                  onTap: () => _showActionSheet(context),
                ),
                _NavItem(
                  icon: Icons.book_outlined,
                  label: 'fitness.goals'.tr(),
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiaryListScreen(),
                      ),
                    );
                  },
                ),
                _NavItem(
                  icon: Icons.task_alt_outlined,
                  label: 'fitness.routine'.tr(),
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoutineScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeightInfo extends StatelessWidget {
  const _WeightInfo({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8F9BB3),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFFFF9447) : const Color(0xFF8F9BB3);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingActionButtonItem extends StatelessWidget {
  const _FloatingActionButtonItem({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFFF9447),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
