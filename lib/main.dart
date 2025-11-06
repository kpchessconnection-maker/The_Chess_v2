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
  // Group 1 State: Holds the selected game mode.
  String? _selectedMode = 'Single Player';

  // Group 2 State: Holds the selected difficulty level.
  String? _selectedDifficulty = 'Easy';

  // --- NEW: Group 3 State for Player Color ---
  PlayerColor _selectedPlayerColor = PlayerColor.white; // Default to White

  // Reusable function for the main menu buttons
  Widget _buildMainMenuButton({required String title}) {
    final bool isSelected = _selectedMode == title;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.amber[300] : Colors.grey[400],
          foregroundColor: Colors.black,
          shadowColor: Colors.greenAccent,
          elevation: isSelected ? 10 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          fixedSize: const Size(300, 120),
        ),
        onPressed: () {
          setState(() {
            if (_selectedMode != title) {
              _selectedMode = title;
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

  // Reusable function for the difficulty buttons
  Widget _buildDifficultyButton({required String level}) {
    final bool isSelected = _selectedDifficulty == level;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.amber[300] : Colors.grey[400],
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          fixedSize: const Size(150, 60),
        ),
        onPressed: () {
          setState(() {
            if (_selectedDifficulty != level) {
              _selectedDifficulty = level;
            }
          });
        },
        // --- CHANGE: Added TextStyle for larger font ---
        child: Text(
          level,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- NEW: Reusable function for the color selection buttons ---
  Widget _buildColorButton({
    required String label,
    required PlayerColor color,
  }) {
    final bool isSelected = _selectedPlayerColor == color;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber[300] : Colors.grey[400],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        fixedSize: const Size(160, 100), // Slightly smaller to fit side-by-side
      ),
      onPressed: () {
        setState(() {
          if (_selectedPlayerColor != color) {
            _selectedPlayerColor = color;
          }
        });
      },
      // --- CHANGE: Added TextStyle for larger font ---
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
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
              // Use a Spacer to push the first group up
              const Spacer(flex: 2),

              // --- Group 1: Game Mode ---
              _buildMainMenuButton(title: 'Single Player'),

              const SizedBox(height: 20),

              // --- Group 2: Difficulty Level ---
              Column(
                children: [
                  _buildDifficultyButton(level: 'Easy'),
                  _buildDifficultyButton(level: 'Medium'),
                  _buildDifficultyButton(level: 'Hard'),
                ],
              ),

              // Use a Spacer to push the next content to the bottom
              const Spacer(flex: 3),

              // --- NEW: Group 3: Player Color ---
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorButton(label: 'Play as White', color: PlayerColor.white),
                    _buildColorButton(label: 'Play as Black', color: PlayerColor.black),
                  ],
                ),
              ),

              // --- NEW: Play Now Button ---
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    fixedSize: const Size(300, 70),
                    elevation: 10,
                  ),
                  onPressed: () {
                    // This is where you would start the game
                    print('Play Now button pressed!');
                    print('Selected Mode: $_selectedMode');
                    print('Selected Difficulty: $_selectedDifficulty');
                    print('Selected Color: $_selectedPlayerColor');
                    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen(...)));
                  },
                  child: const Text(
                    'Play Now!!!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- NEW: Enum for type-safe color selection ---
enum PlayerColor { white, black }
