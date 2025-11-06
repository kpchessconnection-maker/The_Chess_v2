import 'package:flutter/material.dart';
import 'computer_black.dart';

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
  // This variable holds the state of the chessboard.
  String currentFen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  // State for Stockfish "Skill Level" (0-20). Default to Easy.
  int _skillLevel = 5; // Easy: 5, Medium: 10, Hard: 20

  // Group 1 State: Holds the selected game mode.
  String? _selectedMode = 'Single Player';

  // --- REMOVED: No longer need _selectedDifficulty ---

  // Group 3 State for Player Color
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

  // --- UPDATED: Reusable function for the difficulty buttons ---
  Widget _buildDifficultyButton({required String level, required int skillValue}) {
    // Check selection based on the integer skill level
    final bool isSelected = _skillLevel == skillValue;
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
        // Update the _skillLevel state variable on press
        onPressed: () {
          setState(() {
            if (_skillLevel != skillValue) {
              _skillLevel = skillValue;
            }
          });
        },
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

  // Reusable function for the color selection buttons
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

              // --- UPDATED: Group 2: Difficulty Level ---
              Column(
                children: [
                  _buildDifficultyButton(level: 'Easy', skillValue: 5),
                  _buildDifficultyButton(level: 'Medium', skillValue: 10),
                  _buildDifficultyButton(level: 'Hard', skillValue: 20),
                ],
              ),

              // Use a Spacer to push the next content to the bottom
              const Spacer(flex: 3),

              // --- Group 3: Player Color ---
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

              // --- Play Now Button ---
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
                    // Print the integer skill level
                    print('Selected Skill Level: $_skillLevel');
                    print('Selected Color: $_selectedPlayerColor');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          // --- FIXED: Pass the correct, updated skill level ---
                          return BlackPlayerScreen(
                            initialFen: currentFen,
                            //skillLevel: _skillLevel,
                          );
                        },
                      ),
                    );
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

// Enum for type-safe color selection
enum PlayerColor { white, black }
