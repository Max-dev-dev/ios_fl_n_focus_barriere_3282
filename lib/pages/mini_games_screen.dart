import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ios_fl_n_casinobarriere_3282/pages/games/memorize_posiition_screen.dart';
import 'package:ios_fl_n_casinobarriere_3282/pages/games/numerical_memory_screen.dart';

class MiniGamesScreen extends StatefulWidget {
  const MiniGamesScreen({super.key});

  @override
  State<MiniGamesScreen> createState() => _MiniGamesScreenState();
}

class _MiniGamesScreenState extends State<MiniGamesScreen> {
  int? selectedIndex;
  late Timer _timer;
  Duration timeUntilMidnight = _getTimeUntilMidnight();

  final List<String> imagePaths = [
    'assets/images/mini_games/1.png',
    'assets/images/mini_games/2.png',
  ];

  final List<String> titles = ['Numerical Memory', 'Memorize positions'];

  final List<String> memoryExercises = [
    'Try to remember a grocery list of 10 items without writing it down.',
    'Close your eyes and visualize your route to work in detail.',
    'Memorize a short poem or quote and recite it later today.',
    'Play a card-matching game and try to beat your previous score.',
    'Try remembering the birthdays of your family members in order.',
    'Look around you, then close your eyes and list every object you saw.',
  ];

  static Duration _getTimeUntilMidnight() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  String _formattedTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        timeUntilMidnight = _getTimeUntilMidnight();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int dailyExerciseIndex = DateTime.now().day % memoryExercises.length;
    final String dailyExercise = memoryExercises[dailyExerciseIndex];

    return Scaffold(
      appBar: AppBar(centerTitle: false, automaticallyImplyLeading: false),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCDA73C),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.black),
                                const SizedBox(width: 8),
                                Text(
                                  _formattedTime(timeUntilMidnight),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          Text(
                            '🧠 Memory daily exercise:',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        dailyExercise,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mini-games',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: imagePaths.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFFCDA73C)
                                    : Colors.transparent,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(imagePaths[index], fit: BoxFit.cover),
                              Positioned(
                                bottom: 12,
                                left: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: const Color(0xFFCDA73C),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    titles[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                if (selectedIndex != null)
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
                        if (selectedIndex == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NumericalMemoryScreen(),
                            ),
                          );
                        } else if (selectedIndex == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MemorizePositionScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'START',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
