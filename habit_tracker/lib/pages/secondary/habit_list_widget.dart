import 'package:flutter/material.dart';
import 'package:habit_tracker/services/provider.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/services/local_storage.dart';

// Main widget to display all habits for a specific date
class HabitsListView extends StatelessWidget {
  final String date;
  final bool showEmptyState;

  const HabitsListView({
    super.key,
    required this.date,
    this.showEmptyState = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, habitProvider, child) {
        final habits = habitProvider.getHabitsForDate(date);

        // Empty state
        if (habits.isEmpty && showEmptyState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No Habits Found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap + to add your first habit",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // List of habits
        return Column(
          children: habits.entries
              .map((entry) => HabitTile(
                    date: date,
                    habitName: entry.key,
                    isCompleted: entry.value,
                  ))
              .toList(),
        );
      },
    );
  }
}

// Individual habit tile widget
class HabitTile extends StatelessWidget {
  final String date;
  final String habitName;
  final bool isCompleted;

  const HabitTile({
    super.key,
    required this.date,
    required this.habitName,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCompleted
              ? colorScheme.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final provider = Provider.of<DataProvider>(context, listen: false);
          await provider.toggleHabit(date, habitName);
          
          // Optional: Show feedback
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isCompleted ? 'Habit unchecked!' : 'Great job! 🎉',
                ),
                duration: const Duration(milliseconds: 800),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCompleted
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: colorScheme.onPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              
              // Habit name
              Expanded(
                child: Text(
                  habitName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: isCompleted
                        ? colorScheme.onSurface.withValues(alpha: 0.6)
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              
              // Status icon
              Icon(
                isCompleted ? Icons.celebration : Icons.circle_outlined,
                color: isCompleted
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Progress indicator widget
class HabitProgressBar extends StatelessWidget {
  final String date;

  const HabitProgressBar({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, habitProvider, child) {
        final habits = habitProvider.getHabitsForDate(date);
        final completionRate = habitProvider.getCompletionRate(date);
        final completed = habits.values.where((v) => v).length;
        final total = habits.length;

        if (total == 0) return const SizedBox.shrink();

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Progress',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '$completed / $total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: completionRate,
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completionRate == 1.0
                          ? Colors.green
                          : colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}