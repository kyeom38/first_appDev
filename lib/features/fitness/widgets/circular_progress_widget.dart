import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// 원형 진행률 표시 위젯
class CircularProgressWidget extends StatelessWidget {
  /// [CircularProgressWidget] 생성자
  const CircularProgressWidget({
    required this.percentage,
    this.size = 200.0,
    this.strokeWidth = 16.0,
    this.color = Colors.orange,
    super.key,
  });

  /// 진행률 (0-100)
  final double percentage;

  /// 위젯 크기
  final double size;

  /// 선 두께
  final double strokeWidth;

  /// 진행률 색상
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          percentage: percentage,
          strokeWidth: strokeWidth,
          color: color,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentage.toInt()}%',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1F36),
                ),
              ),
              Text(
                'fitness.to_your_goal'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8F9BB3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.color,
  });

  final double percentage;
  final double strokeWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 배경 원
    final backgroundPaint = Paint()
      ..color = const Color(0xFFEDF1F7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 진행률 원
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // 12시 방향부터 시작
    final sweepAngle = 2 * math.pi * (percentage / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color;
  }
}
