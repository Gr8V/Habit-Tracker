import 'package:flutter/material.dart';
import 'package:habit_tracker/globals/data.dart';
import 'package:habit_tracker/services/provider.dart';
import 'package:provider/provider.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  final habitNameController = TextEditingController();
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
                'Add Habit',
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
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Habit Name
              TextField(
                controller: habitNameController,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              // Save Button
              ElevatedButton(
                onPressed: () async {
                  final provider = Provider.of<DataProvider>(context, listen: false);
                  provider.updateHabit(todaysDate, habitNameController.text, false);

                    // Optional: clear fields after adding
                    habitNameController.clear();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Habit added successfully!')),
                    );
                    Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Habit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}