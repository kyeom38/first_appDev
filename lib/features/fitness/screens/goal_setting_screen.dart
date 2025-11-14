import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/fitness_controller.dart';
import 'record_entry_screen.dart';

/// 목표 설정 화면
class GoalSettingScreen extends ConsumerStatefulWidget {
  /// [GoalSettingScreen] 생성자
  const GoalSettingScreen({super.key});

  @override
  ConsumerState<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends ConsumerState<GoalSettingScreen> {
  final _startWeightController = TextEditingController();
  final _goalWeightController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _startWeightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF9447),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1F36),
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

  void _saveGoal() {
    final startWeight = double.tryParse(_startWeightController.text);
    final goalWeight = double.tryParse(_goalWeightController.text);

    if (startWeight == null || goalWeight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('몸무게를 올바르게 입력해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('목표 기간을 선택해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Controller에 목표 저장
    ref.read(fitnessControllerProvider.notifier).setGoal(
          startWeight: startWeight,
          goalWeight: goalWeight,
          targetDate: _selectedDate!,
        );

    // 이전 화면으로 돌아가기
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('목표가 저장되었습니다!'),
        backgroundColor: const Color(0xFFFF9447),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF1A1F36)),
          onPressed: () {},
        ),
        title: Text(
          'fitness.my_diet_plan'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1F36),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1A1F36)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 탭 버튼
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9447),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'fitness.goal_setting'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecordEntryScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8F9BB3),
                      side: const BorderSide(color: Color(0xFFE4E9F2)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'fitness.record'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 제목
            Text(
              'fitness.enter_goals'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'fitness.goal_description'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8F9BB3),
              ),
            ),
            const SizedBox(height: 32),

            // 시작 몸무게
            Text(
              'fitness.start_weight'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _startWeightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A1F36),
              ),
              decoration: InputDecoration(
                hintText: 'fitness.enter_start_weight'.tr(),
                hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
                suffixText: 'kg',
                suffixStyle: const TextStyle(color: Color(0xFF8F9BB3)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 24),

            // 목표 몸무게
            Text(
              'fitness.goal_weight'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _goalWeightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A1F36),
              ),
              decoration: InputDecoration(
                hintText: 'fitness.enter_goal_weight'.tr(),
                hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
                suffixText: 'kg',
                suffixStyle: const TextStyle(color: Color(0xFF8F9BB3)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 24),

            // 목표 기간
            Text(
              'fitness.goal_period'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'fitness.when_to_achieve'.tr()
                          : DateFormat('yyyy년 MM월 dd일').format(_selectedDate!),
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedDate == null
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF1A1F36),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF8F9BB3),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 저장 버튼
            ElevatedButton(
              onPressed: _saveGoal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9447),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'fitness.save_goal'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
