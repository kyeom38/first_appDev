import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/diary_entry.dart';

/// 일기 목록 Provider
final diaryProvider = NotifierProvider<DiaryController, List<DiaryEntry>>(
  DiaryController.new,
);

/// 일기 관리 컨트롤러
class DiaryController extends Notifier<List<DiaryEntry>> {
  @override
  List<DiaryEntry> build() {
    // 초기 상태: 빈 일기 목록
    return [];
  }

  /// 새 일기 추가
  void addEntry({
    required String title,
    String? content,
    String? imagePath,
  }) {
    final newEntry = DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      imagePath: imagePath,
      date: DateTime.now(),
    );

    state = [newEntry, ...state];
  }

  /// 일기 수정
  void updateEntry({
    required String id,
    String? title,
    String? content,
    String? imagePath,
  }) {
    state = [
      for (final entry in state)
        if (entry.id == id)
          entry.copyWith(
            title: title,
            content: content,
            imagePath: imagePath,
          )
        else
          entry,
    ];
  }

  /// 일기 삭제
  void deleteEntry(String id) {
    state = state.where((entry) => entry.id != id).toList();
  }
}
