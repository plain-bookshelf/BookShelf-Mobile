import 'package:bookshelf_mobile/core/network/api_config.dart';

/// API 엔드포인트 상수
abstract class ApiConstants {
  /// 서버 주소 (api_config.dart 에서 주입 — git 추적 제외)
  static const baseUrl1 = ApiConfig.baseUrl1;
  static const baseUrl2 = ApiConfig.baseUrl2;

  // ── Auth ──────────────────────────────────────
  static const signUpMember = '/api/member/signup-member';
  static const signUpOfficial = '/api/member/signup-official';
  static const signUpSocial = '/api/memeber/signup-social';
}
