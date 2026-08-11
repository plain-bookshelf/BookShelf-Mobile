import 'package:bookshelf_mobile/core/network/api_constants.dart';
import 'package:bookshelf_mobile/core/network/cookie_utils.dart';
import 'package:bookshelf_mobile/features/auth/data/models/auth_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookshelf_mobile/core/network/api_client.dart';

// ── 엔드포인트 ──────────────────────────────────────────────
const _kEmailSend = '/api/verification/email/send';
const _kEmailVerify = '/api/verification/email/verify';
const _kFindPassword = '/api/verification/find-password';
const _kLogin = '/api/auth/login';
const _kReissue = '/api/auth/reissue';
const _kLogout = '/api/auth/logout';
const _kPasswordReset = '/api/verification/password-reset';
const _kPasswordChange = '/api/verification/password-change';
const _kOftenReadBookTime = '/often-read-book-time';
const _kDelete = '/delete';

/// login / reissue 응답 래퍼 (model + cookie refresh token)
class AuthLoginResult {
  final AuthResponseModel model;
  final String? refreshToken;
  const AuthLoginResult({required this.model, this.refreshToken});
}

/// Auth 관련 원격 데이터 소스
class AuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSource(this._dio);

  /// POST /signup-member
  ///
  /// [platformType] : WEB | ANDROID | IOS
  Future<AuthResponseModel> signUp({
    required String username,
    required String password,
    required String email,
    required String affiliationName,
    required String verificationCode,
    String platformType = 'ANDROID',
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.signUpMember,
      queryParameters: {'platformType': platformType},
      data: {
        'username': username,
        'password': password,
        'email': email,
        'affiliation_name': affiliationName,
        if (verificationCode.isNotEmpty) 'verification_code': verificationCode,
      },
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return AuthResponseModel.fromJson(data);
  }

  /// POST /signup-official — 관계자(관리자) 회원가입
  ///
  /// [verificationCode] : 관리자 인증 코드
  Future<AuthResponseModel> signUpOfficial({
    required String username,
    required String password,
    required String email,
    required String affiliationName,
    required String verificationCode,
    String platformType = 'ANDROID',
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.signUpOfficial,
      queryParameters: {'platformType': platformType},
      data: {
        'username': username,
        'password': password,
        'email': email,
        'affiliation_name': affiliationName,
        'verification_code': verificationCode,
      },
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return AuthResponseModel.fromJson(data);
  }

  /// POST /api/verification/find-password
  ///
  /// 반환값: register_token (이후 비밀번호 재설정에 사용)
  Future<String> findPassword({
    required String email,
    required String verificationCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _kFindPassword,
      data: {'email': email, 'verification_code': verificationCode},
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return data['register_token'] as String;
  }

  /// POST /email/verify
  Future<void> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      _kEmailVerify,
      data: {'email': email, 'verification_code': verificationCode},
    );
  }

  /// POST /email/send
  ///
  /// [codeType] : VERIFICATION_EMAIL | FIND_PASSWORD
  Future<void> sendEmail({
    required String email,
    required String codeType,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      _kEmailSend,
      queryParameters: {'codeType': codeType},
      data: {'email': email},
    );
  }

  /// POST /login
  ///
  /// [deviceToken] : FCM 디바이스 토큰 (TODO: firebase_messaging 연동 후 실제 토큰으로 교체)
  Future<AuthLoginResult> login({
    required String username,
    required String password,
    String deviceToken = '',
    String platformType = 'ANDROID',
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _kLogin,
      queryParameters: {'platformType': platformType},
      options: Options(headers: {'X-Device-Token': deviceToken}),
      data: {'username': username, 'password': password},
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return AuthLoginResult(
      model: AuthResponseModel.fromJson(data),
      refreshToken: extractSetCookieValue(response, 'refreshToken'),
    );
  }

  /// POST /reissue
  Future<AuthLoginResult> reissue({
    required String refreshToken,
    String platformType = 'ANDROID',
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _kReissue,
      queryParameters: {'platformType': platformType},
      options: Options(headers: {'Cookie': 'refreshToken=$refreshToken'}),
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return AuthLoginResult(
      model: AuthResponseModel.fromJson(data),
      refreshToken:
          extractSetCookieValue(response, 'refreshToken') ?? refreshToken,
    );
  }

  /// POST /often-read-book-time
  Future<void> setReadingTime({
    required String accessToken,
    required String time,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      _kOftenReadBookTime,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {'time': time},
    );
  }

  /// POST /logout
  Future<void> logout({
    required String accessToken,
    String deviceToken = '',
    String platformType = 'ANDROID',
  }) async {
    await _dio.post<Map<String, dynamic>>(
      _kLogout,
      queryParameters: {'platformType': platformType},
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-Device-Token': deviceToken,
        },
      ),
    );
  }

  /// DELETE /delete
  Future<void> deleteAccount({required String accessToken}) async {
    await _dio.delete<Map<String, dynamic>>(
      _kDelete,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// PATCH /password-reset
  Future<void> resetPassword({
    required String registerToken,
    required String email,
    required String newPassword,
  }) async {
    await _dio.patch<Map<String, dynamic>>(
      _kPasswordReset,
      queryParameters: {'registerToken': registerToken},
      data: {'email': email, 'new_password': newPassword},
    );
  }

  /// POST /password-change
  Future<void> changePassword({
    required String accessToken,
    required String existingPassword,
    required String newPassword,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      _kPasswordChange,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {
        'existing_password': existingPassword,
        'new_password': newPassword,
      },
    );
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(dioProvider)),
);
