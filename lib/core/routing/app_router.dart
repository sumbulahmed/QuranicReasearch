import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/main_shell_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/quran/presentation/surah_list_screen.dart';
import '../../features/quran/presentation/surah_detail_screen.dart';
import '../../features/hadith/presentation/hadith_collections_screen.dart';
import '../../features/hadith/presentation/hadith_list_screen.dart';
import '../../features/science/presentation/topics_list_screen.dart';
import '../../features/science/presentation/topic_detail_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/user_library/presentation/bookmarks_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/library/bookmarks',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BookmarksScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/quran/surah/:surahId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final surahId = int.tryParse(state.pathParameters['surahId'] ?? '1') ?? 1;
        return SurahDetailScreen(surahNumber: surahId);
      },
    ),
    GoRoute(
      path: '/hadith/collection/:key',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final key = state.pathParameters['key'] ?? 'bukhari';
        return HadithListScreen(collectionKey: key);
      },
    ),
    GoRoute(
      path: '/science/topic/:topicId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final topicId = state.pathParameters['topicId'] ?? 'embryology';
        return TopicDetailScreen(topicId: topicId);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/quran',
              builder: (context, state) => const SurahListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/hadith',
              builder: (context, state) => const HadithCollectionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/science',
              builder: (context, state) => const TopicsListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
