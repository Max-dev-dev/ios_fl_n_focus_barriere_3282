import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ios_fl_n_casinobarriere_3282/pages/mini_games_screen.dart';
import 'package:ios_fl_n_casinobarriere_3282/pages/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumericalMemoryScreen extends StatefulWidget {
  const NumericalMemoryScreen({super.key});

  @override
  State<NumericalMemoryScreen> createState() => _NumericalMemoryScreenState();
}

class _NumericalMemoryScreenState extends State<NumericalMemoryScreen> {
  final List<int> _generatedNumbers = [];
  final List<int> _shuffledNumbers = [];
  final List<int?> _selectedSlots = List.filled(5, null);

  int _currentIndex = 0;
  bool _showMemoryPhase = true;
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _incrementPlayCount('numerical_memory_plays');
    _startGame();
  }

  Future<void> _incrementPlayCount(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + 1);
    
    final now = DateTime.now();
    final dateKey =
        'play_dates_$key';
    final existingDates = prefs.getStringList(dateKey) ?? [];
    existingDates.add(now.toIso8601String());
    await prefs.setStringList(dateKey, existingDates);
  }

  void _startGame() {
    _generatedNumbers.clear();
    _selectedSlots.fillRange(0, 5, null);
    _showMemoryPhase = true;
    _showResult = false;
    _currentIndex = 0;

    final random = Random();
    for (int i = 0; i < 5; i++) {
      _generatedNumbers.add(random.nextInt(99) + 1);
    }

    _shuffledNumbers
      ..clear()
      ..addAll(_generatedNumbers)
      ..shuffle();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex++;
      });
      if (_currentIndex == 5) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _showMemoryPhase = false;
          });
        });
      }
    });
  }

  void _onNumberSelected(int number) {
    if (_selectedSlots.contains(number)) return;

    final emptyIndex = _selectedSlots.indexOf(null);
    if (emptyIndex != -1) {
      setState(() {
        _selectedSlots[emptyIndex] = number;
      });

      if (!_selectedSlots.contains(null)) {
        _isCorrect =
            List.generate(5, (i) => _selectedSlots[i]) == _generatedNumbers;
        setState(() {
          _showResult = true;
        });
      }
    }
  }

  void _onSlotTapped(int index) {
    setState(() {
      _selectedSlots[index] = null;
    });
  }

  Widget _buildMemoryPhase() {
    return Column(
      children: [
        SizedBox(height: 40.0),
        const Text(
          'Memorize the numbers!',
          style: TextStyle(
            color: Color(0xFFCDA73C),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 50),
        if (_currentIndex < _generatedNumbers.length)
          Text(
            '${_generatedNumbers[_currentIndex]}',
            style: const TextStyle(
              fontSize: 70,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildSelectionPhase() {
    return Column(
      children: [
        SizedBox(height: 40.0),
        const Text(
          'Move the numbers in the correct order',
          style: TextStyle(
            color: Color(0xFFCDA73C),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 50),
        Wrap(
          spacing: 10,
          children: List.generate(5, (index) {
            final number = _selectedSlots[index];
            return GestureDetector(
              onTap: number != null ? () => _onSlotTapped(index) : null,
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  number?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          children:
              _shuffledNumbers.map((number) {
                final isSelected = _selectedSlots.contains(number);
                return GestureDetector(
                  onTap: () => _onNumberSelected(number),
                  child: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey : Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildResultPhase() {
    return Column(
      children: [
        SizedBox(height: 40.0),
        Text(
          _isCorrect
              ? 'Good job you did well!'
              : 'Unfortunately you didn`t get the job done',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFCDA73C),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 100),
        if (_isCorrect == false)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCDA73C),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _startGame();
                });
              },
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        if (_isCorrect == false) SizedBox(height: 20.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCDA73C),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TabsScreen(initialIndex: 1),
                  ),
                ),
            child: const Text(
              'Go to Menu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80.0),
                const Text(
                  'Numerical Memory',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child:
                      _showResult
                          ? _buildResultPhase()
                          : _showMemoryPhase
                          ? _buildMemoryPhase()
                          : _buildSelectionPhase(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
