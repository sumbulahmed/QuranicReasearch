import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/main_shell_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
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
import '../../features/quran/presentation/ayah_detail_screen.dart';
import '../../features/hadith/presentation/hadith_detail_screen.dart';
import '../../features/research/presentation/research_screen.dart';
import '../../features/education/presentation/sunnah_drinking_screen.dart';
import '../../features/sunnah/presentation/screens/sunnah_home_screen.dart';
import '../../features/sunnah/presentation/screens/sunnah_list_screen.dart';
import '../../features/sunnah/presentation/screens/sunnah_detail_screen.dart';
import '../../features/sunnah/presentation/screens/sunnah_video_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
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
      path: '/quran/ayah/:surahId/:ayahId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final surahId = int.tryParse(state.pathParameters['surahId'] ?? '1') ?? 1;
        final ayahId = int.tryParse(state.pathParameters['ayahId'] ?? '1') ?? 1;
        return AyahDetailScreen(surahNumber: surahId, ayahNumber: ayahId);
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
      path: '/hadith/detail/:collectionKey/:hadithNumber',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final collectionKey = state.pathParameters['collectionKey'] ?? 'bukhari';
        final hadithNumber = state.pathParameters['hadithNumber'] ?? '1';
        return HadithDetailScreen(
          collectionKey: collectionKey,
          hadithNumber: hadithNumber,
        );
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
    GoRoute(
      path: '/research',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ResearchScreen(),
    ),
    GoRoute(
      path: '/education/sunnah-drinking',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SunnahDrinkingScreen(),
    ),
    GoRoute(
      path: '/sunnah/category/:categoryId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId'] ?? 'All';
        return SunnahListScreen(category: categoryId);
      },
    ),
    GoRoute(
      path: '/sunnah/drinking-water',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SunnahDetailScreen(sunnahId: 'drinking-water'),
    ),
    GoRoute(
      path: '/sunnah/:sunnahId/video',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final sunnahId = state.pathParameters['sunnahId'] ?? 'drinking-water';
        return SunnahVideoScreen(sunnahId: sunnahId);
      },
    ),
    GoRoute(
      path: '/sunnah/:sunnahId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final sunnahId = state.pathParameters['sunnahId'] ?? 'drinking-water';
        return SunnahDetailScreen(sunnahId: sunnahId);
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
              path: '/sunnah',
              builder: (context, state) => const SunnahHomeScreen(),
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
