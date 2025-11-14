import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:template/features/diary/controllers/diary_controller.dart';
import 'package:template/features/diary/screens/diary_detail_screen.dart';
import 'package:template/features/diary/screens/diary_write_screen.dart';

/// 일기 목록 화면
class DiaryListScreen extends ConsumerWidget {
  /// [DiaryListScreen] 생성자
  const DiaryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaries = ref.watch(diaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1F36)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '나의 기록',
          style: TextStyle(
            color: Color(0xFF1A1F36),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF1A1F36)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiaryWriteScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: diaries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '일기를 작성해주세요',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '오른쪽 상단의 펜 아이콘을 눌러\n일기 작성을 시작하세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: diaries.length,
                itemBuilder: (context, index) {
                  final diary = diaries[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiaryDetailScreen(diary: diary),
                        ),
                      );
                    },
                    child: _DiaryCard(
                      title: diary.title,
                      date: diary.date,
                      imagePath: diary.imagePath,
                      content: diary.content,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

/// 일기 카드 위젯
class _DiaryCard extends StatelessWidget {
  const _DiaryCard({
    required this.title,
    required this.date,
    this.imagePath,
    this.content,
  });

  final String title;
  final DateTime date;
  final String? imagePath;
  final String? content;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('M월 d일');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 배경 이미지 또는 색상
            if (imagePath != null)
              Positioned.fill(
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                ),
              )
            else
              Positioned.fill(
                child: Container(
                  color: _getRandomColor(),
                ),
              ),
            // 어두운 그라데이션 오버레이
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            // 텍스트 내용
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dateFormat.format(date)}, 목요일',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFF5B7C8D),
      const Color(0xFF2D3E50),
      const Color(0xFF8B9D83),
      const Color(0xFF6B7B8C),
      const Color(0xFF7D6B7D),
    ];
    return colors[title.hashCode % colors.length];
  }
}
