import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/routine.dart';

/// 물 마시기 Provider
final waterIntakeProvider = NotifierProvider<WaterIntakeController, WaterIntake>(
  WaterIntakeController.new,
);

/// 물 마시기 컨트롤러
class WaterIntakeController extends Notifier<WaterIntake> {
  @override
  WaterIntake build() {
    return const WaterIntake(
      currentCount: 0,
      goalCount: 7,
    );
  }

  /// 물 마시기 증가
  void increment() {
    if (state.currentCount < state.goalCount) {
      state = state.copyWith(currentCount: state.currentCount + 1);
    }
  }

  /// 물 마시기 초기화
  void reset() {
    state = state.copyWith(currentCount: 0);
  }

  /// 목표 설정
  void setGoal(int goal) {
    state = state.copyWith(goalCount: goal);
  }
}

/// 루틴 목록 Provider
final routineProvider = NotifierProvider<RoutineController, List<Routine>>(
  RoutineController.new,
);

/// 루틴 관리 컨트롤러
class RoutineController extends Notifier<List<Routine>> {
  @override
  List<Routine> build() {
    return [
      Routine(
        id: '1',
        name: '아침 스트레칭',
        goalCount: 1,
        goalUnit: '회',
        weekdays: [1, 2, 3, 4, 5], // 월~금
      ),
    ];
  }

  /// 새 루틴 추가
  void addRoutine({
    required String name,
    required int goalCount,
    required String goalUnit,
    required List<int> weekdays,
  }) {
    final newRoutine = Routine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      goalCount: goalCount,
      goalUnit: goalUnit,
      weekdays: weekdays,
    );

    state = [...state, newRoutine];
  }

  /// 루틴 완료 토글
  void toggleComplete(String id) {
    state = [
      for (final routine in state)
        if (routine.id == id)
          _toggleRoutineComplete(routine)
        else
          routine,
    ];
  }

  Routine _toggleRoutineComplete(Routine routine) {
    final today = _getTodayString();
    final completedDates = List<String>.from(routine.completedDates);

    if (completedDates.contains(today)) {
      completedDates.remove(today);
    } else {
      completedDates.add(today);
    }

    return routine.copyWith(completedDates: completedDates);
  }

  /// 루틴 삭제
  void deleteRoutine(String id) {
    state = state.where((routine) => routine.id != id).toList();
  }

  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
