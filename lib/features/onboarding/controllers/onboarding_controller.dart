import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/onboarding_data.dart';

/// 온보딩 데이터 Provider
final onboardingProvider = NotifierProvider<OnboardingController, OnboardingData>(
  OnboardingController.new,
);

/// 온보딩 컨트롤러
///
/// 온보딩 과정에서 사용자가 입력한 데이터를 관리합니다.
class OnboardingController extends Notifier<OnboardingData> {
  @override
  OnboardingData build() {
    return const OnboardingData();
  }

  /// 닉네임 업데이트
  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  /// 성별 업데이트
  void updateGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }

  /// 나이 업데이트
  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  /// 목적 토글 (복수 선택)
  void togglePurpose(DietPurpose purpose) {
    final purposes = List<DietPurpose>.from(state.purposes);
    if (purposes.contains(purpose)) {
      purposes.remove(purpose);
    } else {
      purposes.add(purpose);
    }
    state = state.copyWith(purposes: purposes);
  }

  /// 키 업데이트
  void updateHeight(double height) {
    state = state.copyWith(height: height);
  }

  /// 체중 업데이트
  void updateWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  /// 허리 사이즈 업데이트
  void updateWaistSize(double waistSize) {
    state = state.copyWith(waistSize: waistSize);
  }

  /// 1단계 데이터 검증 (기본 정보)
  bool validateStep1() {
    return state.nickname != null &&
        state.nickname!.isNotEmpty &&
        state.gender != null &&
        state.age != null &&
        state.age! > 0;
  }

  /// 2단계 데이터 검증 (목적 선택)
  bool validateStep2() {
    return state.purposes.isNotEmpty;
  }

  /// 3단계 데이터 검증 (신체 정보)
  bool validateStep3() {
    return state.height != null &&
        state.height! > 0 &&
        state.weight != null &&
        state.weight! > 0;
  }

  /// 온보딩 완료 후 데이터 초기화
  void reset() {
    state = const OnboardingData();
  }
}
