/// 일기 항목 모델
class DiaryEntry {
  /// [DiaryEntry] 생성자
  const DiaryEntry({
    required this.id,
    required this.title,
    required this.date,
    this.content,
    this.imagePath,
  });

  /// 고유 식별자
  final String id;

  /// 제목 (필수)
  final String title;

  /// 내용 (선택)
  final String? content;

  /// 사진 경로 (선택)
  final String? imagePath;

  /// 작성 날짜
  final DateTime date;

  /// DiaryEntry 복사본 생성
  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? imagePath,
    DateTime? date,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      date: date ?? this.date,
    );
  }
}
