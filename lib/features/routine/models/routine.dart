/// 루틴 항목 모델
class Routine {
  /// [Routine] 생성자
  const Routine({
    required this.id,
    required this.name,
    required this.goalCount,
    this.goalUnit = '회',
    required this.weekdays,
    this.completedDates = const [],
  });

  /// 고유 식별자
  final String id;

  /// 루틴 이름
  final String name;

  /// 목표 횟수/시간
  final int goalCount;

  /// 목표 단위 (회, 시간, 분 등)
  final String goalUnit;

  /// 실천 요일 (0: 일요일, 1: 월요일, ..., 6: 토요일)
  final List<int> weekdays;

  /// 완료한 날짜 목록 (yyyy-MM-dd 형식)
  final List<String> completedDates;

  /// 오늘 완료 여부
  bool get isCompletedToday {
    final today = _getTodayString();
    return completedDates.contains(today);
  }

  /// 오늘이 루틴 실천 요일인지 확인
  bool get isTodayRoutineDay {
    final today = DateTime.now().weekday % 7; // 일요일을 0으로 맞춤
    return weekdays.contains(today);
  }

  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Routine 복사본 생성
  Routine copyWith({
    String? id,
    String? name,
    int? goalCount,
    String? goalUnit,
    List<int>? weekdays,
    List<String>? completedDates,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      goalCount: goalCount ?? this.goalCount,
      goalUnit: goalUnit ?? this.goalUnit,
      weekdays: weekdays ?? this.weekdays,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}

/// 물 마시기 상태 모델
class WaterIntake {
  /// [WaterIntake] 생성자
  const WaterIntake({
    required this.currentCount,
    required this.goalCount,
  });

  /// 현재 마신 횟수
  final int currentCount;

  /// 목표 횟수
  final int goalCount;

  /// 달성률 (0.0 ~ 1.0)
  double get progress => currentCount / goalCount;

  /// WaterIntake 복사본 생성
  WaterIntake copyWith({
    int? currentCount,
    int? goalCount,
  }) {
    return WaterIntake(
      currentCount: currentCount ?? this.currentCount,
      goalCount: goalCount ?? this.goalCount,
    );
  }
}
