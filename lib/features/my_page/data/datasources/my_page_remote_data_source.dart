import 'dart:io';

import 'package:bookshelf_mobile/core/network/api_client.dart';
import 'package:bookshelf_mobile/core/network/cookie_utils.dart';
import 'package:bookshelf_mobile/features/my_page/data/models/affiliation_change_model.dart';
import 'package:bookshelf_mobile/features/my_page/data/models/lending_info_model.dart';
import 'package:bookshelf_mobile/features/my_page/data/models/liked_book_model.dart';
import 'package:bookshelf_mobile/features/my_page/data/models/my_page_model.dart';
import 'package:bookshelf_mobile/features/my_page/data/models/profile_image_upload_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kMyPage = '/myPage';
const _kLendingInfo = '/myPage/lendingInfo';
const _kLikeBook = '/myPage/like-book';
const _kProfileImageUrl = '/api/member/profile-image/url';
const _kNicknameChange = '/api/member/nickname-change';
const _kAffiliationChange = '/api/member/affiliation-change';
const _kValidNickname = '/api/member/valid-nickname';

class MyPageRemoteDataSource {
  final Dio _dio;

  const MyPageRemoteDataSource(this._dio);

  /// GET /mypage
  Future<MyPageModel> getMyPage({required String accessToken}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _kMyPage,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final raw = response.data!['data'];
    final data = raw is Map<String, dynamic>
        ? raw
        : Map<String, dynamic>.from(raw as Map);
    return MyPageModel.fromJson(data);
  }

  /// GET /myPage/lendinginfo — 대여/예약/연체 책 정보
  Future<LendingInfoModel> getLendingInfo({required String accessToken}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _kLendingInfo,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final raw = response.data!['data'];
    final data = raw is Map<String, dynamic>
        ? raw
        : Map<String, dynamic>.from(raw as Map);
    return LendingInfoModel.fromJson(data);
  }

  /// GET /myPage/like-book — 좋아요(찜)한 책 목록
  Future<List<LikedBookModel>> getLikedBooks({
    required String accessToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _kLikeBook,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final list = response.data!['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => LikedBookModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// PATCH /nickname-change — 닉네임 변경
  Future<void> updateNickname({
    required String accessToken,
    required String newNickname,
  }) async {
    await _dio.patch<Map<String, dynamic>>(
      _kNicknameChange,
      data: {'new_nickname': newNickname},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// GET /api/member/valid-nickname — 닉네임 중복 확인
  ///
  /// 사용 가능하면 정상 응답, 이미 사용중이면 서버가 에러 응답(DioException)을 내려줌
  Future<void> validNickname({
    required String accessToken,
    required String nickname,
  }) async {
    await _dio.get<Map<String, dynamic>>(
      _kValidNickname,
      queryParameters: {'nickname': nickname},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// PATCH /api/member/affiliation-change — 소속 변경
  ///
  /// 성공 시 서버가 새 access_token(+refresh_token 쿠키)을 함께 내려줌
  Future<AffiliationChangeModel> updateAffiliation({
    required String accessToken,
    required String newAffiliationName,
  }) async {
    final platformType = Platform.isAndroid
        ? 'ANDROID'
        : Platform.isIOS
        ? 'IOS'
        : 'WEB';

    final response = await _dio.patch<Map<String, dynamic>>(
      _kAffiliationChange,
      queryParameters: {'platformType': platformType},
      data: {'new_affiliation_name': newAffiliationName},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return AffiliationChangeModel.fromJson(
      data,
      refreshToken: extractSetCookieValue(response, 'refreshToken'),
    );
  }

  /// POST /api/member/profile-image/url → S3 PUT 업로드 → public_url 반환
  Future<String> uploadProfileImage({
    required String accessToken,
    required String filePath,
    required String fileName,
    required String contentType,
    required int fileSize,
  }) async {
    // Step 1: presigned URL 발급
    final urlResponse = await _dio.post<Map<String, dynamic>>(
      _kProfileImageUrl,
      data: {
        'file_name': fileName,
        'content_type': contentType,
        'file_size': fileSize,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final result = ProfileImageUploadResult.fromJson(
      urlResponse.data!['data'] as Map<String, dynamic>,
    );

    // Step 2: S3에 직접 PUT (인터셉터 없는 별도 Dio 사용)
    final bytes = await File(filePath).readAsBytes();
    final s3Dio = Dio();
    await s3Dio.put<void>(
      result.uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(
        headers: {'Content-Type': contentType, 'Content-Length': fileSize},
        followRedirects: false,
        validateStatus: (status) => status != null && status < 300,
      ),
    );

    return result.publicUrl;
  }
}

final myPageRemoteDataSourceProvider = Provider<MyPageRemoteDataSource>(
  (ref) => MyPageRemoteDataSource(ref.watch(dioProvider)),
);
