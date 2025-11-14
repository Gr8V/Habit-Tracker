import 'package:flutter/material.dart';
import 'package:habit_tracker/globals/data.dart';
import 'package:habit_tracker/pages/secondary/add_habit.dart';
import 'package:habit_tracker/pages/secondary/habit_list_widget.dart';
import 'package:habit_tracker/services/provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load habits when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: false,
            floating: true, // makes it scroll with content
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
                    getDateWithMonthName(),
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
          SliverToBoxAdapter(
            child: Consumer<DataProvider>(
              builder: (context, habitProvider, child) {
                // Check if loading
                if (habitProvider.isLoading) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final habits = habitProvider.getHabitsForDate(todaysDate);
                // Show empty state if no habits
                if (habits.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "No Habit Found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tap + to add your first habit",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                // Show habits list with progress
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress bar
                      HabitProgressBar(date: todaysDate),
                      
                      // Habits list
                      HabitsListView(
                        date: todaysDate,
                        showEmptyState: false,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.secondary,
        shape: const CircleBorder(),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            //transition and page builder
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => AddHabit(),
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
    );
  }
}