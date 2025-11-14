import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/secondary/user_profile.dart';
import 'package:habit_tracker/theme/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.onSurface.withValues(alpha: 0.15),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Profile'),
              subtitle: const Text('User data, Sync'),
              onTap: () {
                Navigator.push(
                  context,
                  //transition and page builder
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const UserProfile(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 150),
                  )
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              subtitle: const Text('Light, Dark, System'),
              onTap: () {
                Navigator.push(
                  context,
                  //transition and page builder
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ThemeSelectionPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 150),
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, child) {
        return Scaffold(
          //app bar
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Theme',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: 1.1,
                fontFamily: 'Poppins',
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.onSurface.withValues(alpha: 0.1),
                    colorScheme.surface.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              RadioGroup<ThemeMode>(
                groupValue: currentTheme,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    setTheme(value);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile(
                      value: ThemeMode.light,
                      title: Text("Light Mode"),
                    ),
                    RadioListTile(
                      value: ThemeMode.dark,
                      title: Text("Dark Mode"),
                    ),
                    RadioListTile(
                      value: ThemeMode.system,
                      title: Text("System Default"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}