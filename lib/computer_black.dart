// lib/computer_black.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stockfish/stockfish.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess/chess.dart' as chess_logic;

class BlackPlayerScreen extends StatefulWidget {
  final String initialFen;

  const BlackPlayerScreen({super.key, required this.initialFen});

  @override
  State<BlackPlayerScreen> createState() => _BlackPlayerScreenState();
}

// --- CHANGE 1: Add the SingleTickerProviderStateMixin ---
class _BlackPlayerScreenState extends State<BlackPlayerScreen>
    with SingleTickerProviderStateMixin {
  // 1. CONTROLLERS AND STATE VARIABLES
  late final Stockfish stockfish;
  StreamSubscription? _stockfishSubscription;
  final ChessBoardController _boardController = ChessBoardController();
  late chess_logic.Chess _game;
  bool _isEngineThinking = false;

  bool _isGameOver = false;
  String _gameOverMessage = "";

  // --- CHANGE 2: Add an AnimationController ---
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _game = chess_logic.Chess.fromFEN(widget.initialFen);
    _boardController.loadFen(_game.fen);
    stockfish = Stockfish();
    _stockfishSubscription = stockfish.stdout.listen(_handleEngineMessage);

    // --- CHANGE 3: Initialize the AnimationController ---
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Controls blink speed
    );

    stockfish.state.addListener(() {
      if (stockfish.state.value == StockfishState.ready) {
        print("Stockfish engine is ready.");
        if (_game.turn == chess_logic.Color.BLACK) {
          _requestEngineMove();
        }
      }
    });
  }

  // 2. STOCKFISH COMMUNICATION
  void _handleEngineMessage(String message) {
    print("Engine says: $message");

    if (message.startsWith('bestmove')) {
      final parts = message.split(' ');
      if (parts.length >= 2) {
        final bestMove = parts[1];
        _makeEngineMoveOnBoard(bestMove);
      }
    }
  }

  void _requestEngineMove() {
    if (_isEngineThinking || _isGameOver) return;
    setState(() {
      _isEngineThinking = true;
    });
    stockfish.stdin = 'position fen ${_game.fen}';
    stockfish.stdin = 'go movetime 1500';
  }

  // 3. GAME LOGIC AND UI INTERACTION
  void _makeEngineMoveOnBoard(String bestMove) {
    _game.move(bestMove);
    _boardController.makeMove(
      from: bestMove.substring(0, 2),
      to: bestMove.substring(2, 4),
    );

    setState(() {
      _isEngineThinking = false;
    });
    final newFen = _boardController.getFen();
    if (_game.fen != newFen) {
      _game.load(newFen);
    }
    if (_game.in_checkmate) {
      setState(() {
        _isGameOver = true;
        _gameOverMessage = "Checkmate!";
        _animationController.repeat(reverse: true); // Start blinking
      });
    } else if (_game.in_draw) {
      setState(() {
        _isGameOver = true;
        _gameOverMessage = "Draw!";
        _animationController.repeat(reverse: true); // Start blinking
      });
    }
  }

  void _onPlayerMove() {
    final newFen = _boardController.getFen();
    if (_game.fen != newFen) {
      _game.load(newFen);

      if (_game.in_checkmate) {
        setState(() {
          _isGameOver = true;
          _gameOverMessage = "Checkmate!";
          _animationController.repeat(reverse: true); // Start blinking
        });
      } else if (_game.in_draw) {
        setState(() {
          _isGameOver = true;
          _gameOverMessage = "Draw!";
          _animationController.repeat(reverse: true); // Start blinking
        });
      } else {
        _requestEngineMove();
      }
    } else {
      print("Illegal move attempted.");
    }
  }

  void _resetGame() {
    setState(() {
      _isGameOver = false;
      _gameOverMessage = "";
      _animationController.stop(); // Stop blinking
      _game.reset();
      _boardController.loadFen(_game.fen);
      if (_game.turn == chess_logic.Color.BLACK) {
        _requestEngineMove();
      }
    });
  }

  @override
  void dispose() {
    _stockfishSubscription?.cancel();
    stockfish.dispose();
    _boardController.dispose();
    // --- CHANGE 4: Dispose the animation controller ---
    _animationController.dispose();
    super.dispose();
  }

  // 4. WIDGET BUILD METHOD AND UI HELPERS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play against Stockfish')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AbsorbPointer(
                absorbing: _isGameOver,
                child: ChessBoard(
                  controller: _boardController,
                  boardColor: BoardColor.brown,
                  boardOrientation: PlayerColor.white,
                  onMove: _onPlayerMove,
                ),
              ),
            ),
          ),
          if (_isGameOver)
            _buildGameOverBanner()
          else
            _buildThinkingIndicator(),
        ],
      ),
    );
  }

  Widget _buildGameOverBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      color: Colors.green.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- CHANGE 5: Wrap the Text widget in a FadeTransition ---
          FadeTransition(
            opacity: _animationController,
            child: Text(
              _gameOverMessage,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isEngineThinking ? "Stockfish is thinking..." : "Your move.",
            style: const TextStyle(fontSize: 18),
          ),
          if (_isEngineThinking)
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
        ],
      ),
    );
  }
}
