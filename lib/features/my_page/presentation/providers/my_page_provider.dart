import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/features/my_page/data/repositories/my_page_repository_impl.dart';
import 'package:bookshelf_mobile/features/my_page/domain/entities/my_page_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageState {
  final bool isLoading;
  final MyPageInfo? data;
  final String? errorMessage;

  const MyPageState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  MyPageState copyWith({
    bool? isLoading,
    MyPageInfo? data,
    String? errorMessage,
  }) =>
      MyPageState(
        isLoading: isLoading ?? this.isLoading,
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
}

final myPageProvider =
    NotifierProvider<MyPageNotifier, MyPageState>(MyPageNotifier.new);
