import 'package:bookshelf_mobile/core/router/route_extras.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_in/change_password_page.dart';

import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_in/find_password_page.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_in/login_page.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_up/auth_code_page.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_up/email_input_page.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_up/email_verify_page.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_up/find_library_page.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_up/password_page.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_up/register_complete_page.dart';
import 'package:bookshelf_mobile/features/auth/presentation/pages/sign_up/role_select_page.dart';
import 'package:bookshelf_mobile/features/ai/presentation/pages/ai_page.dart';
import 'package:bookshelf_mobile/features/admin/presentation/pages/admin_page.dart';
import 'package:bookshelf_mobile/features/ranking/presentation/pages/ranking_page.dart';
import 'package:bookshelf_mobile/features/notification/presentation/pages/notification_detail_page.dart';
import 'package:bookshelf_mobile/features/notification/presentation/pages/notification_list_page.dart';
import 'package:bookshelf_mobile/features/book/presentation/pages/book_detail_page.dart';
import 'package:bookshelf_mobile/features/book/presentation/pages/reviews_page.dart';
import 'package:bookshelf_mobile/features/cart/presentation/pages/cart_page.dart';
import 'package:bookshelf_mobile/features/home/domain/entities/main_book.dart';
import 'package:bookshelf_mobile/features/home/presentation/pages/book_list_page.dart';
import 'package:bookshelf_mobile/features/home/presentation/pages/home_page.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/pages/my_page.dart';
import 'package:bookshelf_mobile/features/my_page/presentation/pages/rental_history_page.dart';
import 'package:bookshelf_mobile/features/onboarding/presentation/pages/onboarding_complete_page.dart';
import 'package:bookshelf_mobile/features/onboarding/presentation/pages/onboarding_genre_page.dart';
import 'package:bookshelf_mobile/features/onboarding/presentation/pages/onboarding_reading_time_page.dart';
import 'package:bookshelf_mobile/features/onboarding/presentation/pages/onboarding_recommend_page.dart';
import 'package:bookshelf_mobile/features/onboarding/presentation/pages/onboarding_start_page.dart';
import 'package:bookshelf_mobile/features/search/presentation/pages/search_page.dart';
import 'package:go_router/go_router.dart';

/// 앱 전체 라우트 경로 상수
abstract class AppRoutes {
  // ── Sign In ──
  static const login              = '/';
  static const findPassword       = '/find-password';
  static const findPasswordVerify = '/find-password/verify';
  static const changePassword     = '/change-password';

  // ── Sign Up ──
  static const register           = '/register';
  static const registerEmail      = '/register/email';
  static const registerEmailVerify= '/register/email-verify';
  static const registerPassword   = '/register/password';
  static const registerLibrary    = '/register/library';
  static const registerAuthCode   = '/register/auth-code';
  static const registerComplete   = '/register/complete';

  // ── Main ──
  static const home               = '/home';
  static const search             = '/search';
  static const cart               = '/cart';
  static const ai                 = '/ai';

  // ── Admin ──
  static const admin              = '/admin';

  // ── Ranking ──
  static const ranking            = '/ranking';

  // ── Notification ──
  static const notifications       = '/notifications';
  static const notificationDetail  = '/notifications/:id';

  /// /notifications/:id 경로 생성 헬퍼
  static String notificationDetailOf(String id) => '/notifications/$id';

  // ── Book ──
  static const bookDetail         = '/book/:id';
  static const bookReviews        = '/book/:id/reviews';

  // ── Book List ──
  static const bookList           = '/book-list/:type';
  static String bookListOf(String type) => '/book-list/$type';

  // ── My Page ──
  static const myPage             = '/my-page';
  static const rentalHistory      = '/my-page/rental-history';

  // ── Onboarding ──
  static const onboarding         = '/onboarding';
  static const onboardingGenre    = '/onboarding/genre';
  static const onboardingTime     = '/onboarding/reading-time';
  static const onboardingRecommend= '/onboarding/recommend';
  static const onboardingComplete = '/onboarding/complete';

  /// /book/:id 경로 생성 헬퍼
  static String bookDetailOf(String id) => '/book/$id';

  /// /book/:id/reviews 경로 생성 헬퍼
  static String bookReviewsOf(String id) => '/book/$id/reviews';
}

// 앱 전역에서 router에 접근하기 위한 인스턴스 (AuthInterceptor에서 사용)
late GoRouter appRouter;

GoRouter createAppRouter({String initialLocation = AppRoutes.login}) => appRouter = GoRouter(
  initialLocation: initialLocation,
  routes: [
    // ──────────────── Sign In ────────────────
    GoRoute(
      path: AppRoutes.login,
      builder: (ctx, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.findPassword,
      builder: (ctx, state) => const FindPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.findPasswordVerify,
      builder: (ctx, state) {
        final extra = state.extra as FindPasswordVerifyExtra;
        return FindPasswordVerifyPage(email: extra.email);
      },
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      builder: (ctx, state) {
        final extra = state.extra as ChangePasswordExtra;
        return ChangePasswordPage(
          registerToken: extra.registerToken,
          email: extra.email,
        );
      },
    ),

    // ──────────────── Sign Up ────────────────
    GoRoute(
      path: AppRoutes.register,
      builder: (ctx, state) => const RoleSelectPage(),
    ),
    GoRoute(
      path: AppRoutes.registerEmail,
      builder: (ctx, state) {
        final isAdmin = state.extra as bool;
        return EmailInputPage(isAdmin: isAdmin);
      },
    ),
    GoRoute(
      path: AppRoutes.registerEmailVerify,
      builder: (ctx, state) {
        final extra = state.extra as EmailVerifyExtra;
        return EmailVerifyPage(email: extra.email, isAdmin: extra.isAdmin);
      },
    ),
    GoRoute(
      path: AppRoutes.registerPassword,
      builder: (ctx, state) {
        final isAdmin = state.extra as bool;
        return PasswordPage(isAdmin: isAdmin);
      },
    ),
    GoRoute(
      path: AppRoutes.registerLibrary,
      builder: (ctx, state) {
        final isAdmin = state.extra as bool;
        return FindLibraryPage(isAdmin: isAdmin);
      },
    ),
    GoRoute(
      path: AppRoutes.registerAuthCode,
      builder: (ctx, state) => const AuthCodePage(),
    ),
    GoRoute(
      path: AppRoutes.registerComplete,
      builder: (ctx, state) => const RegisterCompletePage(),
    ),

    // ──────────────── Main ────────────────
    GoRoute(
      path: AppRoutes.home,
      builder: (ctx, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (ctx, state) => const SearchPage(),
    ),
    GoRoute(
      path: AppRoutes.cart,
      builder: (ctx, state) => const CartPage(),
    ),
    GoRoute(
      path: AppRoutes.ai,
      builder: (ctx, state) => const AiPage(),
    ),

    // ──────────────── Admin ────────────────
    GoRoute(
      path: AppRoutes.admin,
      builder: (ctx, state) => const AdminPage(),
    ),
    GoRoute(
      path: AppRoutes.ranking,
      builder: (ctx, state) => const RankingPage(),
    ),

    // ──────────────── Notification ────────────────
    GoRoute(
      path: AppRoutes.notifications,
      builder: (ctx, state) => const NotificationListPage(),
    ),
    GoRoute(
      path: AppRoutes.notificationDetail,
      builder: (ctx, state) {
        final id = state.pathParameters['id'] ?? '';
        return NotificationDetailPage(notificationId: id);
      },
    ),

    // ──────────────── Book ────────────────
    GoRoute(
      path: AppRoutes.bookDetail,
      builder: (ctx, state) {
        final id = state.pathParameters['id'] ?? '';
        return BookDetailPage(bookId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.bookReviews,
      builder: (ctx, state) {
        final id = state.pathParameters['id'] ?? '';
        return ReviewsPage(bookId: id);
      },
    ),

    // ──────────────── Book List ────────────────
    GoRoute(
      path: AppRoutes.bookList,
      builder: (ctx, state) {
        final type = state.pathParameters['type'] ?? 'POPULAR';
        final bookFindType = type == 'RECENT'
            ? BookFindType.RECENT
            : BookFindType.POPULAR;
        return BookListPage(bookFindType: bookFindType);
      },
    ),

    // ──────────────── My Page ────────────────
    GoRoute(
      path: AppRoutes.myPage,
      builder: (ctx, state) => const MyPage(),
    ),
    GoRoute(
      path: AppRoutes.rentalHistory,
      builder: (ctx, state) => const RentalHistoryPage(),
    ),

    // ──────────────── Onboarding ────────────────
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (ctx, state) => const OnboardingStartPage(),
    ),
    GoRoute(
      path: AppRoutes.onboardingGenre,
      builder: (ctx, state) => const OnboardingGenrePage(),
    ),
    GoRoute(
      path: AppRoutes.onboardingTime,
      builder: (ctx, state) => const OnboardingReadingTimePage(),
    ),
    GoRoute(
      path: AppRoutes.onboardingRecommend,
      builder: (ctx, state) => const OnboardingRecommendPage(),
    ),
    GoRoute(
      path: AppRoutes.onboardingComplete,
      builder: (ctx, state) => const OnboardingCompletePage(),
    ),
  ],
);
