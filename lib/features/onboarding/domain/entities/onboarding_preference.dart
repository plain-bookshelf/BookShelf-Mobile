/// 온보딩 사용자 취향 도메인 엔티티
class OnboardingPreference {
  final List<String> selectedGenres;
  final String? readingTime;

  const OnboardingPreference({
    required this.selectedGenres,
    this.readingTime,
  });
}
