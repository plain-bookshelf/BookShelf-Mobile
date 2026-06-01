import 'package:bookshelf_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bookshelf_mobile/features/auth/domain/entities/user.dart';
import 'package:bookshelf_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AuthRepository 구현체 (Data Layer)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;

  const AuthRepositoryImpl(this._remote);

  @override
  Future<User> register({
    required String username,
    required String email,
    required String password,
    required String affiliationName,
    required String verificationCode,
  }) async {
    final result = await _remote.signUp(
      username: username,
      email: email,
      password: password,
      affiliationName: affiliationName,
      verificationCode: verificationCode,
    );

    return User(
      id: result.username,
      email: email,
      name: result.nickname.isNotEmpty ? result.nickname : result.username,
      isAdmin: result.isAdmin,
    );
  }

  @override
  Future<User> login({required String username, required String password}) async {
    final result = await _remote.login(
      username: username,
      password: password,
    );
    return User(
      id: result.model.username,
      email: '',
      name: result.model.nickname.isNotEmpty
          ? result.model.nickname
          : result.model.username,
      isAdmin: result.model.isAdmin,
      accessToken: result.model.accessToken,
      refreshToken: result.refreshToken,
    );
  }

  @override
  Future<User> reissue({required String refreshToken}) async {
    final result = await _remote.reissue(refreshToken: refreshToken);
    return User(
      id: result.model.username,
      email: '',
      name: result.model.nickname.isNotEmpty
          ? result.model.nickname
          : result.model.username,
      isAdmin: result.model.isAdmin,
      accessToken: result.model.accessToken,
      refreshToken: result.refreshToken,
    );
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    await _remote.sendEmail(email: email, codeType: 'VERIFICATION_EMAIL');
  }

  @override
  Future<void> sendFindPasswordEmail(String email) async {
    await _remote.sendEmail(email: email, codeType: 'FIND_PASSWORD');
  }

  @override
  Future<void> verifyEmailCode({required String email, required String code}) async {
    await _remote.verifyEmail(email: email, verificationCode: code);
  }

  @override
  Future<void> deleteAccount({required String accessToken}) async {
    await _remote.deleteAccount(accessToken: accessToken);
  }

  @override
  Future<void> logout({required String accessToken}) async {
    await _remote.logout(accessToken: accessToken);
  }

  @override
  Future<String> findPassword({
    required String email,
    required String verificationCode,
  }) async {
    return _remote.findPassword(email: email, verificationCode: verificationCode);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    // TODO: 별도 엔드포인트 필요 시 연동
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({
    required String registerToken,
    required String email,
    required String newPassword,
  }) async {
    await _remote.resetPassword(
      registerToken: registerToken,
      email: email,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> changePassword({
    required String accessToken,
    required String existingPassword,
    required String newPassword,
  }) async {
    await _remote.changePassword(
      accessToken: accessToken,
      existingPassword: existingPassword,
      newPassword: newPassword,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

