import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/fitness_controller.dart';
import 'goal_setting_screen.dart';

/// 기록 입력 화면
class RecordEntryScreen extends ConsumerStatefulWidget {
  /// [RecordEntryScreen] 생성자
  const RecordEntryScreen({super.key});

  @override
  ConsumerState<RecordEntryScreen> createState() => _RecordEntryScreenState();
}

class _RecordEntryScreenState extends ConsumerState<RecordEntryScreen> {
  final _weightController = TextEditingController();
  final _caloriesIntakeController = TextEditingController();
  final _caloriesBurnedController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _caloriesIntakeController.dispose();
    _caloriesBurnedController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    final weight = double.tryParse(_weightController.text);
    final caloriesIntake = int.tryParse(_caloriesIntakeController.text);
    final caloriesBurned = int.tryParse(_caloriesBurnedController.text);

    // 최소 하나의 값은 입력되어야 함
    if (weight == null && caloriesIntake == null && caloriesBurned == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 하나 이상의 값을 입력해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Controller에 기록 저장
    ref.read(fitnessControllerProvider.notifier).addDailyRecord(
          weight: weight,
          caloriesIntake: caloriesIntake,
          caloriesBurned: caloriesBurned,
        );

    // 이전 화면으로 돌아가기
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('기록이 저장되었습니다!'),
        backgroundColor: Color(0xFFFF9447),
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
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GoalSettingScreen(),
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
              'fitness.record_today'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'fitness.daily_record_description'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8F9BB3),
              ),
            ),
            const SizedBox(height: 32),

            // 몸무게
            Text(
              'fitness.weight'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A1F36),
              ),
              decoration: InputDecoration(
                hintText: 'fitness.enter_weight'.tr(),
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

            // 섭취 칼로리
            Text(
              'fitness.calories_intake'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _caloriesIntakeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A1F36),
              ),
              decoration: InputDecoration(
                hintText: 'fitness.enter_calories_intake'.tr(),
                hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
                suffixText: 'kcal',
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

            // 소비 칼로리
            Text(
              'fitness.calories_burned'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _caloriesBurnedController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A1F36),
              ),
              decoration: InputDecoration(
                hintText: 'fitness.enter_calories_burned'.tr(),
                hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
                suffixText: 'kcal',
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
            const SizedBox(height: 40),

            // 저장 버튼
            ElevatedButton(
              onPressed: _saveRecord,
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
                'fitness.save_record'.tr(),
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
