import 'package:bookshelf_mobile/features/affiliation/data/repositories/affiliation_repository_impl.dart';
import 'package:bookshelf_mobile/features/affiliation/domain/entities/affiliation.dart';
import 'package:bookshelf_mobile/features/affiliation/domain/repositories/affiliation_repository.dart';
import 'package:bookshelf_mobile/features/my_page/data/repositories/my_page_repository_impl.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/affiliation_change_result.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/liked_book.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/my_page_info.dart';
import 'package:bookshelf_mobile/features/my_page/domain/repositories/my_page_repository.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/pages/affiliation_change_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 소속 목록은 성공 응답으로 고정
class _FakeAffiliationRepository implements AffiliationRepository {
  @override
  Future<List<Affiliation>> getAffiliations() async => const [
    Affiliation(id: 1, name: '대마고2'),
    Affiliation(id: 2, name: '대마고3'),
  ];
}

/// 소속 변경만 실패시키는 가짜 리포지토리
class _FailingMyPageRepository implements MyPageRepository {
  final DioException error;

  _FailingMyPageRepository(this.error);

  @override
  Future<AffiliationChangeResult> updateAffiliation({
    required String accessToken,
    required String newAffiliationName,
  }) async => throw error;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('테스트에서 사용하지 않는 메서드');

  @override
  Future<MyPageInfo> getMyPage({required String accessToken}) =>
      throw UnimplementedError();

  @override
  Future<LendingInfo> getLendingInfo({required String accessToken}) =>
      throw UnimplementedError();

  @override
  Future<List<LikedBook>> getLikedBooks({required String accessToken}) =>
      throw UnimplementedError();

  @override
  Future<String> uploadProfileImage({
    required String accessToken,
    required String filePath,
    required String fileName,
    required String contentType,
    required int fileSize,
  }) => throw UnimplementedError();

  @override
  Future<void> updateNickname({
    required String accessToken,
    required String newNickname,
  }) => throw UnimplementedError();

  @override
  Future<void> validNickname({
    required String accessToken,
    required String nickname,
  }) => throw UnimplementedError();
}

/// 실제 서버가 내려준 에러 응답 형태로 DioException 생성
DioException _serverError({
  required int statusCode,
  required String code,
  required String message,
}) {
  final options = RequestOptions(
    path: '/api/member/affiliation-change',
    method: 'PATCH',
  );
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: options,
      statusCode: statusCode,
      data: {
        'code': code,
        'message': message,
        'status': statusCode,
        'path': '/api/member/affiliation-change',
      },
    ),
  );
}

Future<void> _submitAffiliationChange(
  WidgetTester tester,
  DioException error,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        affiliationRepositoryProvider.overrideWithValue(
          _FakeAffiliationRepository(),
        ),
        myPageRepositoryProvider.overrideWithValue(
          _FailingMyPageRepository(error),
        ),
      ],
      child: const MaterialApp(home: AffiliationChangePage()),
    ),
  );
  // 소속 목록 로딩 완료
  await tester.pumpAndSettle();

  // 검색 → 결과 선택 → 변경하기
  await tester.enterText(find.byType(TextField).first, '대마고2');
  await tester.pumpAndSettle();
  await tester.tap(find.text('대마고2').last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('변경하기'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('소속 변경 400 실패 시 서버 message가 에러 모달로 표시된다', (tester) async {
    await _submitAffiliationChange(
      tester,
      _serverError(
        statusCode: 400,
        code: 'ILLEGAL_ARGUMENT_ERROR',
        message: '유효하지 않은 값이 들어왔습니다.',
      ),
    );

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('소속 변경 실패'), findsOneWidget);
    expect(find.text('유효하지 않은 값이 들어왔습니다.'), findsOneWidget);
    // DioException 덤프가 화면에 새어나오지 않아야 한다
    expect(find.textContaining('DioException'), findsNothing);
  });

  testWidgets('소속 변경 500 실패 시 서버 message가 에러 모달로 표시된다', (tester) async {
    await _submitAffiliationChange(
      tester,
      _serverError(
        statusCode: 500,
        code: 'INTERNAL_SERVER_ERROR',
        message: '서버 오류가 발생하였습니다.',
      ),
    );

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('서버 오류가 발생하였습니다.'), findsOneWidget);
    expect(find.textContaining('DioException'), findsNothing);
  });

  testWidgets('서버 message가 없으면 기본 문구로 대체된다', (tester) async {
    final options = RequestOptions(path: '/api/member/affiliation-change');
    await _submitAffiliationChange(
      tester,
      DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      ),
    );

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('네트워크에 연결할 수 없습니다. 인터넷 상태를 확인해주세요.'), findsOneWidget);
  });
}
