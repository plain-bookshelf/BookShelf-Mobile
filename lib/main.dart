import 'package:bookshelf_mobile/core/network/auth_session_provider.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('access_token');
  final savedRefresh = prefs.getString('refresh_token');
  final savedUsername = prefs.getString('username');
  final savedAffiliationName = prefs.getString('affiliation_name');
  final hasToken = savedToken != null && savedToken.isNotEmpty;

  runApp(
    ProviderScope(
      overrides: [
        storedAccessTokenProvider.overrideWithValue(savedToken),
        storedRefreshTokenProvider.overrideWithValue(savedRefresh),
        storedUsernameProvider.overrideWithValue(savedUsername),
        storedAffiliationNameProvider.overrideWithValue(savedAffiliationName),
      ],
      child: BookShelfApp(
        initialLocation: hasToken ? AppRoutes.home : AppRoutes.login,
      ),
    ),
  );
}

class BookShelfApp extends StatelessWidget {
  final String initialLocation;

  const BookShelfApp({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '책마루',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3AC73B),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: createAppRouter(initialLocation: initialLocation),
    );
  }
}
