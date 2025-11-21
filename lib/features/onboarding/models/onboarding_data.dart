/// 온보딩 데이터 모델
class OnboardingData {
  /// [OnboardingData] 생성자
  const OnboardingData({
    this.nickname,
    this.password,
    this.gender,
    this.birthDate,
    this.purposes = const [],
    this.height,
    this.weight,
    this.waistSize,
  });

  /// 닉네임
  final String? nickname;

  // 비밀번호 설정 - 선택사항
  final String? password;

  /// 성별
  final Gender? gender;

  /// 나이
  final DateTime? birthDate;

  // 나이 계산 getter
  int? get age {
    if (birthDate == null) return null;
    final today = DateTime.now();
    int age = today.year - birthDate!.year;
    if (today.month < birthDate!.month ||
        (today.month == birthDate!.month && today.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  /// 다이어트 목적 (복수 선택 가능)
  final List<DietPurpose> purposes;

  /// 키 (cm)
  final double? height;

  /// 현재 체중 (kg)
  final double? weight;

  /// 허리 사이즈 (cm) - 선택사항
  final double? waistSize;

  /// BMI 계산
  double? get bmi {
    if (height == null || weight == null) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// 기초대사량 계산 (Harris-Benedict 공식)
  /// 남성: 88.362 + (13.397 x 체중kg) + (4.799 x 키cm) - (5.677 x 나이)
  /// 여성: 447.593 + (9.247 x 체중kg) + (3.098 x 키cm) - (4.330 x 나이)
  double? get bmr {
    if (weight == null || height == null || age == null || gender == null) {
      return null;
    }

    switch (gender!) {
      case Gender.male:
        return 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
      case Gender.female:
        return 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
    }
  }

  /// copyWith 메서드
  OnboardingData copyWith({
    String? nickname,
    String? password,
    Gender? gender,
    DateTime? birthDate,
    List<DietPurpose>? purposes,
    double? height,
    double? weight,
    double? waistSize,
  }) {
    return OnboardingData(
      nickname: nickname ?? this.nickname,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      purposes: purposes ?? this.purposes,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      waistSize: waistSize ?? this.waistSize,
    );
  }
}

/// 성별
enum Gender {
  /// 남성
  male,

  /// 여성
  female,
}

/// 성별 확장
extension GenderExtension on Gender {
  /// 성별 표시 문자열
  String get displayName {
    switch (this) {
      case Gender.male:
        return '남성';
      case Gender.female:
        return '여성';
    }
  }
}

/// 다이어트 목적
enum DietPurpose {
  /// 근육량 증가
  muscleGain,

  /// 체중 감량
  weightLoss,

  /// 체형 유지
  maintenance,

  /// 건강 개선
  health,

  /// 식습관 개선
  nutrition,

  /// 기타
  other,
}

/// 다이어트 목적 확장
extension DietPurposeExtension on DietPurpose {
  /// 목적 표시 문자열
  String get displayName {
    switch (this) {
      case DietPurpose.muscleGain:
        return '근육량 증가';
      case DietPurpose.weightLoss:
        return '체중 감량';
      case DietPurpose.maintenance:
        return '체형 유지';
      case DietPurpose.health:
        return '건강 개선';
      case DietPurpose.nutrition:
        return '식습관 개선';
      case DietPurpose.other:
        return '기타';
    }
  }

  /// 아이콘 이모지 (임시)
  String get icon {
    switch (this) {
      case DietPurpose.muscleGain:
        return '💪';
      case DietPurpose.weightLoss:
        return '⚖️';
      case DietPurpose.maintenance:
        return '🧘';
      case DietPurpose.health:
        return '❤️';
      case DietPurpose.nutrition:
        return '🍴';
      case DietPurpose.other:
        return '📌';
    }
  }
}
