import 'dart:io';

import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/my_page/data/repositories/my_page_repository_impl.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/lending_info.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/liked_book.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/my_page_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageState {
  final bool isLoading;
  final bool isUploadingImage;
  final MyPageInfo? data;
  final String? errorMessage;

  const MyPageState({
    this.isLoading = false,
    this.isUploadingImage = false,
    this.data,
    this.errorMessage,
  });

  MyPageState copyWith({
    bool? isLoading,
    bool? isUploadingImage,
    MyPageInfo? data,
    String? errorMessage,
  }) =>
      MyPageState(
        isLoading: isLoading ?? this.isLoading,
        isUploadingImage: isUploadingImage ?? this.isUploadingImage,
        data: data ?? this.data,
        errorMessage: errorMessage,
      );
}

class MyPageNotifier extends Notifier<MyPageState> {
  @override
  MyPageState build() => const MyPageState();

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      final info = await ref
          .read(myPageRepositoryProvider)
          .getMyPage(accessToken: accessToken);
      state = state.copyWith(isLoading: false, data: info);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 프로필 이미지 업로드 후 성공 시 로컬 상태를 즉시 반영
  Future<void> uploadProfileImage(File file) async {
    state = state.copyWith(isUploadingImage: true, errorMessage: null);
    try {
      final accessToken = ref.read(authSessionProvider).accessToken ?? '';
      final fileName = file.path.split('/').last;
      final ext = fileName.split('.').last.toLowerCase();
      final contentType = _contentTypeFromExt(ext);
      final fileSize = await file.length();

      final publicUrl = await ref
          .read(myPageRepositoryProvider)
          .uploadProfileImage(
            accessToken: accessToken,
            filePath: file.path,
            fileName: fileName,
            contentType: contentType,
            fileSize: fileSize,
          );

      final updated = state.data != null
          ? MyPageInfo(
              profileImage: publicUrl,
              nickname: state.data!.nickname,
              mostLittleLeftRentalTitle: state.data!.mostLittleLeftRentalTitle,
              mostLittleLeftRentalDate: state.data!.mostLittleLeftRentalDate,
              rentedBookCount: state.data!.rentedBookCount,
              reservedBookCount: state.data!.reservedBookCount,
              overdueBookCount: state.data!.overdueBookCount,
            )
          : null;

      state = state.copyWith(isUploadingImage: false, data: updated);
    } catch (e) {
      state = state.copyWith(
        isUploadingImage: false,
        errorMessage: e.toString(),
      );
    }
  }

  static String _contentTypeFromExt(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }
}

final myPageProvider =
    NotifierProvider<MyPageNotifier, MyPageState>(MyPageNotifier.new);

/// 대여/예약/연체 책 정보 (GET /myPage/lendinginfo)
final lendingInfoProvider = FutureProvider.autoDispose<LendingInfo>((ref) async {
  final accessToken = ref.read(authSessionProvider).accessToken ?? '';
  return ref
      .read(myPageRepositoryProvider)
      .getLendingInfo(accessToken: accessToken);
});

/// 좋아요(찜)한 책 목록 (GET /myPage/like-book)
final likedBooksProvider =
    FutureProvider.autoDispose<List<LikedBook>>((ref) async {
  final accessToken = ref.read(authSessionProvider).accessToken ?? '';
  return ref
      .read(myPageRepositoryProvider)
      .getLikedBooks(accessToken: accessToken);
});
