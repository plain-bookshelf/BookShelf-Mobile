/// 서버 주소 등 환경별 설정 템플릿
///
/// 사용법: 이 파일을 `api_config.dart` 로 복사한 뒤 실제 서버 주소를 입력하세요.
///   cp lib/core/network/api_config.example.dart lib/core/network/api_config.dart
///
/// api_config.dart 는 .gitignore 에 등록되어 git 에 커밋되지 않습니다.
abstract class ApiConfig {
  static const baseUrl1 = 'https://your-server-address';
  static const baseUrl2 = 'https://your-recommend-server-address';
}
