import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:template/features/diary/models/diary_entry.dart';
import 'package:template/features/diary/controllers/diary_controller.dart';

/// 일기 상세보기 화면
class DiaryDetailScreen extends ConsumerWidget {
  /// [DiaryDetailScreen] 생성자
  const DiaryDetailScreen({
    required this.diary,
    super.key,
  });

  /// 표시할 일기
  final DiaryEntry diary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');

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
          dateFormat.format(diary.date),
          style: const TextStyle(
            color: Color(0xFF1A1F36),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('일기 삭제'),
                  content: const Text('이 일기를 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(diaryProvider.notifier).deleteEntry(diary.id);
                        Navigator.pop(context); // dialog
                        Navigator.pop(context); // detail screen
                      },
                      child: const Text(
                        '삭제',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Text(
                diary.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 24),

              // 사진 (있는 경우)
              if (diary.imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(diary.imagePath!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 내용
              if (diary.content != null && diary.content!.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    diary.content!,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                ),
              ] else if (diary.imagePath == null) ...[
                // 사진도 없고 내용도 없을 때
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '작성된 내용이 없습니다',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
