import 'package:flutter/material.dart';
import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';

class QuranicResearchApp extends StatelessWidget {
  const QuranicResearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quran & Science Research',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
