import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';

class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.parchmentSubtle,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
              width: 1.0,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          height: 68,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.parchmentSubtle,
          indicatorColor: selectedColor.withValues(alpha: 0.12),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: selectedColor),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded, color: selectedColor),
              label: 'Quran',
            ),
            NavigationDestination(
              icon: const Icon(Icons.library_books_outlined),
              selectedIcon: Icon(Icons.library_books_rounded, color: selectedColor),
              label: 'Hadith',
            ),
            NavigationDestination(
              icon: const Icon(Icons.science_outlined),
              selectedIcon: Icon(Icons.science_rounded, color: selectedColor),
              label: 'Science',
            ),
            NavigationDestination(
              icon: const Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search_rounded, color: selectedColor),
              label: 'Search',
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: selectedColor),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
