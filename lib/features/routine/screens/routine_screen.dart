import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:template/features/routine/controllers/routine_controller.dart';
import 'package:template/features/routine/screens/add_routine_screen.dart';

/// 루틴 메인 화면
class RoutineScreen extends ConsumerWidget {
  /// [RoutineScreen] 생성자
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waterIntake = ref.watch(waterIntakeProvider);
    final routines = ref.watch(routineProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1F36)),
          onPressed: () => Navigator.pop(context),
        ),
        //leadingWidth: 0,
        title: const Text(
          '오늘의 루틴',
          style: TextStyle(
            color: Color(0xFF1A1F36),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF1A1F36)),
        //     onPressed: () {
        //       // TODO: 캘린더 기능
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 물 마시기 섹션
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '물 마시기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1F36),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 원형 게이지
                    GestureDetector(
                      onTap: () {
                        ref.read(waterIntakeProvider.notifier).increment();
                      },
                      child: CustomPaint(
                        size: const Size(150, 150),
                        painter: WaterGaugePainter(
                          progress: waterIntake.progress,
                          currentCount: waterIntake.currentCount,
                          goalCount: waterIntake.goalCount,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '컵 아이콘을 눌러 섭취량을 기록하세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 나의 루틴 섹션
              const Text(
                '추가 루틴',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 16),

              // 루틴 리스트
              ...routines.map((routine) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CheckboxListTile(
                    value: routine.isCompletedToday,
                    onChanged: (value) {
                      ref
                          .read(routineProvider.notifier)
                          .toggleComplete(routine.id);
                    },
                    title: Text(
                      routine.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: routine.isCompletedToday
                            ? Colors.grey[400]
                            : const Color(0xFF1A1F36),
                        decoration: routine.isCompletedToday
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    activeColor: const Color(0xFFFF9447),
                    side: const BorderSide(color: Color(0xFFFF9447), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRoutineScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFFF9447),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

/// 물 마시기 게이지 페인터
class WaterGaugePainter extends CustomPainter {
  WaterGaugePainter({
    required this.progress,
    required this.currentCount,
    required this.goalCount,
  });

  final double progress;
  final int currentCount;
  final int goalCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 배경 원
    final backgroundPaint = Paint()
      ..color = const Color(0xFFF7F9FC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    canvas.drawCircle(center, radius - 6, backgroundPaint);

    // 진행 원 (오렌지색)
    final progressPaint = Paint()
      ..color = const Color(0xFFFF9447)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // 컵 아이콘 그리기 (간단한 사각형)
    final iconPaint = Paint()
      ..color = const Color(0xFFFF9447)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final cupRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(0, -10),
        width: 40,
        height: 45,
      ),
      const Radius.circular(4),
    );

    canvas.drawRRect(cupRect, iconPaint);

    // 손잡이
    final handlePath = Path()
      ..moveTo(center.dx + 20, center.dy - 5)
      ..quadraticBezierTo(
        center.dx + 30,
        center.dy,
        center.dx + 20,
        center.dy + 5,
      );
    canvas.drawPath(handlePath, iconPaint);

    // 텍스트 (현재/목표)
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$currentCount/$goalCount',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1F36),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy + 25,
      ),
    );
  }

  @override
  bool shouldRepaint(WaterGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.currentCount != currentCount ||
        oldDelegate.goalCount != goalCount;
  }
}
