import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/dashboard/screens/qr_code_screen.dart';
import '../features/teacher_news/screens/teacher_news_screen.dart';
import '../features/teacher_news/screens/announcement_detail_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String qrCode = '/qr-code';
  static const String teacherNews = '/teacher-news';
  static const String announcementDetail = '/announcement-detail';
  static const String settings = '/settings';

  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: login,
      redirect: (context, state) {
        final authState = ref.watch(authStateProvider);
        
        return authState.when(
          data: (user) {
            final isLoggedIn = user != null;
            final location = state.uri.toString();
            final isOnLoginPage = location == login || location == register;
            
            if (!isLoggedIn && !isOnLoginPage) {
              return login;
            }
            
            if (isLoggedIn && isOnLoginPage) {
              return dashboard;
            }
            
            return null;
          },
          loading: () => null,
          error: (error, stack) => login,
        );
      },
      routes: [
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: register,
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: qrCode,
          name: 'qr-code',
          builder: (context, state) => const QrCodeScreen(),
        ),
        GoRoute(
          path: teacherNews,
          name: 'teacher-news',
          builder: (context, state) => const TeacherNewsScreen(),
        ),
        GoRoute(
          path: '$announcementDetail/:id',
          name: 'announcement-detail',
          builder: (context, state) {
            final announcementId = state.pathParameters['id']!;
            return AnnouncementDetailScreen(announcementId: announcementId);
          },
        ),
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'صفحة غير موجودة',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'المسار: ${state.uri}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(dashboard),
                child: const Text('العودة للرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter(ref);
});
