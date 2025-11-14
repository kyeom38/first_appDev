import 'package:flutter/material.dart';

import '../models/progress_model.dart';

/// 운동 로그 아이템 위젯
class LogItemWidget extends StatelessWidget {
  /// [LogItemWidget] 생성자
  const LogItemWidget({
    required this.log,
    super.key,
  });

  /// 피트니스 로그
  final FitnessLog log;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIcon(),
              color: _getIconColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  log.subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8F9BB3),
                  ),
                ),
              ],
            ),
          ),
          // 시간
          Text(
            log.time,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8F9BB3),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (log.type) {
      case LogType.weight:
        return const Color(0xFFFFF4E6);
      case LogType.calories:
        return const Color(0xFFFFF4E6);
      case LogType.goal:
        return const Color(0xFFFFF4E6);
    }
  }

  Color _getIconBackgroundColor() {
    switch (log.type) {
      case LogType.weight:
        return const Color(0xFFFFE4CC);
      case LogType.calories:
        return const Color(0xFFFFE4CC);
      case LogType.goal:
        return const Color(0xFFFFE4CC);
    }
  }

  Color _getIconColor() {
    switch (log.type) {
      case LogType.weight:
        return const Color(0xFFFF9447);
      case LogType.calories:
        return const Color(0xFFFF9447);
      case LogType.goal:
        return const Color(0xFFFF9447);
    }
  }

  IconData _getIcon() {
    switch (log.type) {
      case LogType.weight:
        return Icons.scale_outlined;
      case LogType.calories:
        return Icons.local_fire_department_outlined;
      case LogType.goal:
        return Icons.emoji_events_outlined;
    }
  }
}
