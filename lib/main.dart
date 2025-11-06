import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false, primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {'/': (context) => const HomeScreen()},
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- CHANGE: Initialize with default values ---
  // Group 1 State: Holds the selected game mode. Default to 'Single Player'.
  String? _selectedMode = 'Single Player';

  // Group 2 State: Holds the selected difficulty level. Default to 'Easy'.
  String? _selectedDifficulty = 'Easy';

  // Reusable function for the main menu buttons (Single Player, Multi Player)
  Widget _buildMainMenuButton({required String title}) {
    // Check if this button is the currently selected one in its group.
    final bool isSelected = _selectedMode == title;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // ** REQUIREMENT MET: Change color based on selection state **
          backgroundColor: isSelected ? Colors.amber[300] : Colors.grey[400],
          foregroundColor: Colors.black,
          // Keep text color consistent
          shadowColor: Colors.greenAccent,
          elevation: isSelected ? 10 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          fixedSize: const Size(300, 120),
        ),
        onPressed: () {
          // ** REQUIREMENT MET: Independent group logic **
          setState(() {
            // This is a simple toggle. If it's already selected, deselect it. Otherwise, select it.
            if (_selectedMode == title) {
              _selectedMode = null; // Deselect if tapped again
            } else {
              _selectedMode = title; // Select this one
            }
          });
        },
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 36,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Reusable function for the smaller difficulty buttons
  Widget _buildDifficultyButton({required String level}) {
    // Check if this button is the currently selected one in its group.
    final bool isSelected = _selectedDifficulty == level;
    // --- CHANGE: Added Padding widget to surround the button ---
    return Padding(
      // Adds 8 pixels of padding on the top and bottom of each button
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // ** REQUIREMENT MET: Change color based on selection state **
          backgroundColor: isSelected ? Colors.amber[300] : Colors.grey[400],
          foregroundColor: Colors.black, // Keep text color consistent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          fixedSize: const Size(150, 60),
        ),
        onPressed: () {
          // ** REQUIREMENT MET: Independent group logic **
          setState(() {
            // If the tapped button is already selected, deselect it.
            if (_selectedDifficulty == level) {
              _selectedDifficulty = null;
            } else {
              // Otherwise, make it the selected one.
              _selectedDifficulty = level;
            }
            print("Difficulty set to: $_selectedDifficulty");
          });
        },
        child: Text(level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('@@ Chess @@'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Group 1: Game Mode ---
              _buildMainMenuButton(title: 'Single Player'),
              _buildMainMenuButton(title: 'Multi Player'),

              // Add some space between the two groups
              const SizedBox(height: 30),

              // --- Group 2: Difficulty Level ---
              // This outer Padding is no longer strictly necessary but can be kept
              // to control the space around the entire group of buttons.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // The padding is now applied by the builder function itself
                    _buildDifficultyButton(level: 'Easy'),
                    _buildDifficultyButton(level: 'Medium'),
                    _buildDifficultyButton(level: 'Hard'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
