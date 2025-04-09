import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToBrainExerciseScreen(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrainExerciseScreen(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonImages = List.generate(
      4,
      (index) => 'assets/images/buttons/${index + 1}.png',
    );

    final brainImages = List.generate(
      4,
      (index) => 'assets/images/brain_exercise/${index + 1}.png',
    );

    final List<String> memoryTips = [
      '🧠 Get enough sleep to help your brain consolidate memories.',
      '🧘‍♀️ Practice mindfulness or meditation to improve focus and memory.',
      '🏃 Stay physically active to increase oxygen flow to your brain.',
      '🧩 Challenge your brain with new skills or puzzles regularly.',
      '📚 Read more — it helps build new neural connections.',
      '🥦 Eat brain-boosting foods like nuts, berries, and fish.',
      '📝 Write things down — it helps reinforce memory.',
      '💧 Stay hydrated. Even mild dehydration can impair concentration.',
      '⏰ Take regular breaks when learning — spaced repetition improves retention.',
      '🎶 Listen to music. Certain types can enhance mood and memory.',
      '👥 Socialize more. Meaningful conversation stimulates the brain.',
      '🌿 Spend time in nature — it reduces stress and improves focus.',
      '🧴 Avoid multitasking. Focused attention helps retain information.',
      '👃 Use smell associations — certain scents can trigger memory.',
      '🎯 Set goals and visualize success to increase motivation and memory anchoring.',
    ];

    final String randomTip = memoryTips[Random().nextInt(memoryTips.length)];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Menu',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip: $randomTip',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Brain exercises',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20.0),
                for (int i = 0; i < buttonImages.length; i++)
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap:
                          () => _navigateToBrainExerciseScreen(
                            context,
                            brainImages[i],
                          ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          buttonImages[i],
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrainExerciseScreen extends StatelessWidget {
  final String imagePath;

  const BrainExerciseScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Brain exercises',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
