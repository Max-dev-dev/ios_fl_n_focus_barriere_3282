import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:ios_fl_n_casinobarriere_3282/pages/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemorizePositionScreen extends StatefulWidget {
  const MemorizePositionScreen({super.key});

  @override
  State<MemorizePositionScreen> createState() => _MemorizePositionScreenState();
}

class _MemorizePositionScreenState extends State<MemorizePositionScreen> {
  final int gridSize = 9;
  final List<int> itemPositions = [];
  final List<int> userSelected = [];
  bool showIcons = true;
  bool isChoosing = false;
  bool showCorrectAnswer = false;
  bool showResult = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _incrementPlayCount();
    _generateRandomPositions();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showIcons = false;
        isChoosing = true;
      });
    });
  }

  Future<void> _incrementPlayCount() async {
  final prefs = await SharedPreferences.getInstance();
  final currentCount = prefs.getInt('memorize_position_plays') ?? 0;
  await prefs.setInt('memorize_position_plays', currentCount + 1);
}


  void _generateRandomPositions() {
    final rand = Random();
    final Set<int> positions = {};
    while (positions.length < 4) {
      positions.add(rand.nextInt(gridSize));
    }
    itemPositions
      ..clear()
      ..addAll(positions);
  }

  void _onTileTap(int index) {
    if (!isChoosing) return;
    setState(() {
      if (userSelected.contains(index)) {
        userSelected.remove(index);
      } else {
        if (userSelected.length < 4) {
          userSelected.add(index);
        }
      }
    });
  }

  void _onNext() {
    setState(() {
      isChoosing = false;
      showCorrectAnswer = true;
    });
  }

  void _onFinish() {
    setState(() {
      showCorrectAnswer = false;
      showResult = true;
      isCorrect = const SetEquality().equals(
        itemPositions.toSet(),
        userSelected.toSet(),
      );
    });
  }

  void _onRetry() {
    setState(() {
      userSelected.clear();
      showIcons = true;
      isChoosing = false;
      showCorrectAnswer = false;
      showResult = false;
      isCorrect = false;
      _generateRandomPositions();
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showIcons = false;
        isChoosing = true;
      });
    });
  }

  Widget _buildGridItem(int index) {
    final bool isItem = itemPositions.contains(index);
    final bool isSelected = userSelected.contains(index);
    Widget content = const SizedBox.shrink();

    if ((showIcons || showCorrectAnswer) && isItem) {
      int iconIndex = itemPositions.indexOf(index) + 1;
      content = Image.asset(
        'assets/images/mini_games/memorize_posiition/$iconIndex.png',
        width: 70,
        height: 70,
      );
    }

    return GestureDetector(
      onTap: () => _onTileTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color:
              (showIcons || showCorrectAnswer)
                  ? Colors.white
                  : isSelected
                  ? Colors.white
                  : const Color(0xFF444444),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: content),
      ),
    );
  }

  Widget _buildGrid() {
    if (showResult) return const SizedBox.shrink();

    return Column(
      children: [
        const Text(
          "Memorize where the pictures are and put them in the correct boxes!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFCDA73C),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 310,
          height: 310,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: List.generate(gridSize, _buildGridItem),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    if (showResult) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            isCorrect
                ? "Good job you did well!"
                : "Unfortunately you didn't get the job done",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFCDA73C),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            child: Image.asset(
              'assets/images/mini_games/memorize_posiition/memorize_position_logo.png',
            ),
          ),
          const SizedBox(height: 30),
          if (!isCorrect)
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
                onPressed: _onRetry,
                child: const Text(
                  'Retry',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          const SizedBox(height: 20),
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
                      builder: (_) => const TabsScreen(initialIndex: 1),
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

    if (showCorrectAnswer) {
      return SizedBox(
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
          onPressed: _onFinish,
          child: const Text(
            'Finish',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    if (isChoosing) {
      return SizedBox(
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
          onPressed: userSelected.length == 4 ? _onNext : null,
          child: const Text(
            'Next',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 5, end: 0),
        duration: const Duration(seconds: 5),
        builder: (_, double value, __) {
          return SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: value / 5,
                  color: Colors.amber,
                  backgroundColor: Colors.white,
                  strokeWidth: 6,
                ),
                Text(
                  '${value.ceil()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildGrid(),
              const SizedBox(height: 30),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }
}
