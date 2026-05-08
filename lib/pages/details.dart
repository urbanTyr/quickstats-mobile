import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dataset.dart';

class DetailsPage extends StatelessWidget {
  final Dataset dataset;

  const DetailsPage({
    super.key,
    required this.dataset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          dataset.name,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

        body: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // values card
                    SizedBox(
                      width: 80,

                      child: Card(
                        color: Colors.yellow[100],
                        child: Padding(
                          padding: const EdgeInsets.all(12),

                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  'Values',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                ...dataset.values.map((value) {

                                  return Column(
                                    children: [

                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 6),

                                        child: Text(
                                          value.toStringAsFixed(1),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // chart card
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              show: true,
                            ),

                            borderData: FlBorderData(
                              show: true,
                            ),

                            gridData: FlGridData(
                              show: true,
                            ),

                            lineBarsData: [
                              LineChartBarData(
                                spots: dataset.values
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return FlSpot(
                                    entry.key.toDouble(),
                                    entry.value,
                                  );
                                }).toList(),

                                isCurved: true,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // bottom stats card
              Card(
                color: Colors.blueGrey[100],
                elevation: 3,

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Text('Min: ${dataset.min}'),
                      Text('Q1: ${dataset.q1}'),
                      Text('Median: ${dataset.median}'),
                      Text('Q3: ${dataset.q3}'),
                      Text('Max: ${dataset.max}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}