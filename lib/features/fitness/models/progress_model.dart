/// 운동 진행 상황 데이터 모델
class ProgressModel {
  /// [ProgressModel] 생성자
  const ProgressModel({
    required this.currentWeight,
    required this.startWeight,
    required this.goalWeight,
    required this.logs,
    this.targetDate,
  });

  /// 현재 몸무게 (kg)
  final double currentWeight;

  /// 시작 몸무게 (kg)
  final double startWeight;

  /// 목표 몸무게 (kg)
  final double goalWeight;

  /// 목표 달성 날짜
  final DateTime? targetDate;

  /// 운동 로그 목록
  final List<FitnessLog> logs;

  /// 목표 달성 퍼센트 (0-100)
  double get progressPercentage {
    if (startWeight == goalWeight) return 100.0;
    final totalDiff = startWeight - goalWeight;
    final currentDiff = startWeight - currentWeight;
    final percentage = (currentDiff / totalDiff) * 100;
    return percentage.clamp(0.0, 100.0);
  }

  /// 최근 몸무게 기록 (가장 최근 1개)
  FitnessLog? get latestWeightLog {
    try {
      return logs.firstWhere((log) => log.type == LogType.weight);
    } catch (e) {
      return null;
    }
  }

  /// 총 칼로리 소모량 (오늘 기준)
  int get totalCaloriesBurned {
    int total = 0;
    for (final log in logs) {
      if (log.type == LogType.calories && log.title.contains('소모')) {
        final match = RegExp(r'(\d+)').firstMatch(log.title);
        if (match != null) {
          total += int.parse(match.group(1)!);
        }
      }
    }
    return total;
  }

  /// 총 칼로리 섭취량 (오늘 기준)
  int get totalCaloriesIntake {
    int total = 0;
    for (final log in logs) {
      if (log.type == LogType.calories && log.title.contains('섭취')) {
        final match = RegExp(r'(\d+)').firstMatch(log.title);
        if (match != null) {
          total += int.parse(match.group(1)!);
        }
      }
    }
    return total;
  }

  /// 최근 목표 달성 기록 (가장 최근 1개, 목표 설정 제외)
  FitnessLog? get latestGoalLog {
    try {
      return logs.firstWhere(
        (log) => log.type == LogType.goal && !log.title.contains('목표 설정'),
      );
    } catch (e) {
      return null;
    }
  }

  /// D-day 계산 (목표 날짜까지 남은 일수)
  int? get dDay {
    if (targetDate == null) return null;
    final now = DateTime.now();
    final difference = targetDate!.difference(
      DateTime(now.year, now.month, now.day),
    );
    return difference.inDays;
  }

  /// D-day 표시 문자열
  String? get dDayString {
    final days = dDay;
    if (days == null) return null;
    if (days < 0) return 'D+${days.abs()}';
    if (days == 0) return 'D-Day';
    return 'D-$days';
  }

  /// ProgressModel 복사본 생성
  ProgressModel copyWith({
    double? currentWeight,
    double? startWeight,
    double? goalWeight,
    List<FitnessLog>? logs,
    DateTime? targetDate,
  }) {
    return ProgressModel(
      currentWeight: currentWeight ?? this.currentWeight,
      startWeight: startWeight ?? this.startWeight,
      goalWeight: goalWeight ?? this.goalWeight,
      logs: logs ?? this.logs,
      targetDate: targetDate ?? this.targetDate,
    );
  }
}

/// 운동 로그 타입
enum LogType {
  /// 몸무게 기록
  weight,

  /// 칼로리 소모
  calories,

  /// 목표 달성
  goal,
}

/// 피트니스 로그 데이터 모델
class FitnessLog {
  /// [FitnessLog] 생성자
  const FitnessLog({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  /// 로그 타입
  final LogType type;

  /// 제목
  final String title;

  /// 부제목 (상세 정보)
  final String subtitle;

  /// 기록 시간
  final String time;
}
