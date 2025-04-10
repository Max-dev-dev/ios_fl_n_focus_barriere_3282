import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int numericalMemoryPlays = 0;
  int memorizePositionPlays = 0;
  List<int> weeklyActivity = List.filled(7, 0);

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      numericalMemoryPlays = prefs.getInt('numerical_memory_plays') ?? 0;
      memorizePositionPlays = prefs.getInt('memorize_position_plays') ?? 0;
    });

    final dates1 = prefs.getStringList('play_dates_numerical_memory_plays') ?? [];
    final dates2 = prefs.getStringList('play_dates_memorize_position_plays') ?? [];

    final game1ByDay = _getWeeklyActivity(dates1);
    final game2ByDay = _getWeeklyActivity(dates2);

    setState(() {
      for (int i = 0; i < 7; i++) {
        weeklyActivity[i] = game1ByDay[i] + game2ByDay[i];
      }
    });
  }

  List<int> _getWeeklyActivity(List<String> isoDates) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
    final endOfWeek = startOfWeek.add(const Duration(days: 6)); // Sunday
    final dailyCounts = List.filled(7, 0);

    for (var dateStr in isoDates) {
      final date = DateTime.tryParse(dateStr);
      if (date != null && date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && date.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        final dayIndex = date.weekday - 1;
        dailyCounts[dayIndex]++;
      }
    }
    return dailyCounts;
  }

  double _calculateProgress(int plays) {
    final result = plays * 3;
    return result.isFinite ? result.clamp(0, 100).toDouble() : 0;
  }

  void _showAchievementsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Accomplishments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 8.0, right: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/achieve/${index + 1}.png',
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressItem({
    required String imagePath,
    required double progressPercent,
  }) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          width: 140,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (progressPercent.isFinite ? progressPercent / 100 : 0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFCDA73C),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${progressPercent.isFinite ? progressPercent.toInt() : 0}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final numericalProgress = _calculateProgress(numericalMemoryPlays);
    final memorizeProgress = _calculateProgress(memorizePositionPlays);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Progress',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined, color: Colors.white, size: 30),
            onPressed: () => _showAchievementsModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weekly Chart
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCDA73C), width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'This Week',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 10,
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                  return Text(
                                    days[value.toInt()],
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(7, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: weeklyActivity[index].toDouble(),
                                  width: 16,
                                  color: const Color(0xFFCDA73C),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Progress in mini-games',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  _buildProgressItem(
                    imagePath: 'assets/images/mini_games/1.png',
                    progressPercent: numericalProgress,
                  ),
                  const SizedBox(width: 30),
                  _buildProgressItem(
                    imagePath: 'assets/images/mini_games/2.png',
                    progressPercent: memorizeProgress,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}