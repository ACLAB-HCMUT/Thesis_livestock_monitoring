import 'package:do_an_app/screens/cow_analytic_screen/utils/format_helpers.dart';
import 'package:do_an_app/screens/cow_analytic_screen/widgets/custom_pie_chart.dart';
import 'package:do_an_app/screens/cow_analytic_screen/widgets/legend_item.dart';
import 'package:flutter/material.dart';

class StatusDistributionCard extends StatelessWidget {
  final Map<String, Duration> statusDurations;
  const StatusDistributionCard(this.statusDurations, {super.key});

  @override
  Widget build(BuildContext context) {
    Duration totalTime = Duration.zero;
    statusDurations.forEach((status, duration) {
      totalTime += duration;
    });
    final eatingPercentage = totalTime.inSeconds > 0
        ? statusDurations['eating']!.inSeconds / totalTime.inSeconds
        : 0.0;
    final walkingPercentage = totalTime.inSeconds > 0
        ? statusDurations['walking']!.inSeconds / totalTime.inSeconds
        : 0.0;
    final idlePercentage = totalTime.inSeconds > 0
        ? statusDurations['idle']!.inSeconds / totalTime.inSeconds
        : 0.0;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: totalTime.inSeconds == 0
                  ? const Center(child: Text('No data available yet'))
                  : Column(
                      children: [
                        Expanded(
                          child: CustomPieChart(
                            sections: [
                              PieChartSection(
                                value: eatingPercentage,
                                color: Colors.green,
                                label: 'Eating',
                              ),
                              PieChartSection(
                                value: walkingPercentage,
                                color: Colors.blue,
                                label: 'Walking',
                              ),
                              PieChartSection(
                                value: idlePercentage,
                                color: Colors.orange,
                                label: 'Idle',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LegendItem(
                              'Eating',
                              Colors.green,
                              FormatHelpers.formatDuration(
                                  statusDurations['eating']!),
                              eatingPercentage,
                            ),
                            LegendItem(
                              'Walking',
                              Colors.blue,
                              FormatHelpers.formatDuration(
                                  statusDurations['walking']!),
                              walkingPercentage,
                            ),
                            LegendItem(
                              'Idle',
                              Colors.orange,
                              FormatHelpers.formatDuration(
                                  statusDurations['idle']!),
                              idlePercentage,
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
