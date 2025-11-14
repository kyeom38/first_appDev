import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:template/features/diary/controllers/diary_controller.dart';

/// 일기 작성 화면
class DiaryWriteScreen extends ConsumerStatefulWidget {
  /// [DiaryWriteScreen] 생성자
  const DiaryWriteScreen({super.key});

  @override
  ConsumerState<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends ConsumerState<DiaryWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedImagePath;
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImagePath = null;
    });
  }

  void _saveEntry() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목을 입력해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final content = _contentController.text.trim();

    ref.read(diaryProvider.notifier).addEntry(
          title: title,
          content: content.isNotEmpty ? content : null,
          imagePath: _selectedImagePath,
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          dateFormat.format(DateTime.now()),
          style: const TextStyle(
            color: Color(0xFF1A1F36),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              const Text(
                '제목',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A1F36),
                ),
                decoration: InputDecoration(
                  hintText: '오늘의 일기 제목',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 내용
              const Text(
                '내용',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A1F36),
                ),
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: '오늘의 식단, 운동, 건강을 자유롭게 기록해보세요',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // 사진 첨부
              const Text(
                '사진 첨부',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 12),

              if (_selectedImagePath != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_selectedImagePath!),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: _removeImage,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '사진 추가',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: _saveEntry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9447),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              '저장',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
