import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/progress_model.dart';

/// 피트니스 진행 상황 Provider
final fitnessControllerProvider =
    NotifierProvider<FitnessController, ProgressModel>(
  FitnessController.new,
);

/// 피트니스 진행 상황 Controller
class FitnessController extends Notifier<ProgressModel> {
  @override
  ProgressModel build() {
    // 초기 빈 상태
    return const ProgressModel(
      currentWeight: 0,
      startWeight: 0,
      goalWeight: 0,
      logs: [],
    );
  }

  /// 몸무게 업데이트
  void updateWeight(double newWeight) {
    final diff = newWeight - state.currentWeight;
    final diffStr = diff > 0 ? '+${diff.toStringAsFixed(1)}' : diff.toStringAsFixed(1);

    final newLog = FitnessLog(
      type: LogType.weight,
      title: '몸무게 기록',
      subtitle: '어제 대비 $diffStr kg',
      time: '방금',
    );

    state = state.copyWith(
      currentWeight: newWeight,
      logs: [newLog, ...state.logs],
    );
  }

  /// 운동 로그 추가
  void addCalorieLog({
    required int calories,
    required String activity,
  }) {
    final newLog = FitnessLog(
      type: LogType.calories,
      title: '$calories 칼로리 소모',
      subtitle: activity,
      time: '방금',
    );

    state = state.copyWith(
      logs: [newLog, ...state.logs],
    );
  }

  /// 목표 달성 로그 추가
  void addGoalLog(String achievement) {
    final newLog = FitnessLog(
      type: LogType.goal,
      title: '목표 달성!',
      subtitle: achievement,
      time: '방금',
    );

    state = state.copyWith(
      logs: [newLog, ...state.logs],
    );
  }

  /// 목표 설정
  void setGoal({
    required double startWeight,
    required double goalWeight,
    required DateTime targetDate,
  }) {
    state = state.copyWith(
      startWeight: startWeight,
      currentWeight: startWeight,
      goalWeight: goalWeight,
      targetDate: targetDate,
    );

    // 목표 설정 로그 추가
    final newLog = FitnessLog(
      type: LogType.goal,
      title: '새로운 목표 설정!',
      subtitle: '${startWeight.toStringAsFixed(1)}kg → ${goalWeight.toStringAsFixed(1)}kg',
      time: '방금',
    );

    state = state.copyWith(
      logs: [newLog, ...state.logs],
    );
  }

  /// 일일 기록 추가 (몸무게, 섭취 칼로리, 소비 칼로리)
  void addDailyRecord({
    double? weight,
    int? caloriesIntake,
    int? caloriesBurned,
  }) {
    final logs = <FitnessLog>[];

    // 몸무게 기록 (입력된 경우에만)
    if (weight != null && weight > 0) {
      final diff = weight - state.currentWeight;
      final diffStr = diff > 0 ? '+${diff.toStringAsFixed(1)}' : diff.toStringAsFixed(1);

      logs.add(FitnessLog(
        type: LogType.weight,
        title: '몸무게 기록',
        subtitle: state.currentWeight > 0 ? '어제 대비 $diffStr kg' : '${weight.toStringAsFixed(1)} kg',
        time: '방금',
      ));
    }

    // 섭취 칼로리 기록
    if (caloriesIntake != null && caloriesIntake > 0) {
      logs.add(FitnessLog(
        type: LogType.calories,
        title: '$caloriesIntake 칼로리 섭취',
        subtitle: '오늘 섭취량',
        time: '방금',
      ));
    }

    // 소비 칼로리 기록
    if (caloriesBurned != null && caloriesBurned > 0) {
      logs.add(FitnessLog(
        type: LogType.calories,
        title: '$caloriesBurned 칼로리 소모',
        subtitle: '오늘 운동량',
        time: '방금',
      ));
    }

    // 몸무게가 입력된 경우에만 currentWeight 업데이트
    state = state.copyWith(
      currentWeight: weight ?? state.currentWeight,
      logs: [...logs, ...state.logs],
    );
  }
}
