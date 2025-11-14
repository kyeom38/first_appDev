import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/fitness_controller.dart';
import '../models/progress_model.dart';
import '../widgets/log_item_widget.dart';

/// 기록 히스토리 화면
class HistoryScreen extends ConsumerWidget {
  /// [HistoryScreen] 생성자
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(fitnessControllerProvider);

    // 목표 설정 로그만 필터링
    final goalLogs = progress.logs
        .where((log) => log.type == LogType.goal)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1F36)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'fitness.history'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1F36),
          ),
        ),
      ),
      body: goalLogs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 64,
                    color: const Color(0xFF8F9BB3).withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '아직 기록이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF8F9BB3).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: goalLogs.length,
              itemBuilder: (context, index) {
                final log = goalLogs[index];
                return LogItemWidget(log: log);
              },
            ),
    );
  }
}
