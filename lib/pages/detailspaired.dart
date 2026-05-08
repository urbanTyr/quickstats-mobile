import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/datasetpaired.dart';
import 'dart:math';

class DetailsPairedPage
    extends StatelessWidget {

  final PairedDataset dataset;

  const DetailsPairedPage({
    super.key,
    required this.dataset,
  });

  Color getRelationshipColor() {

    final r = dataset.correlation;

    if (r >= 0.7) {
      return Colors.green;
    }

    if (r >= 0.3) {
      return Colors.lightGreen;
    }

    if (r <= -0.7) {
      return Colors.red;
    }

    if (r <= -0.3) {
      return Colors.orange;
    }

    return Colors.lightBlue;
  }

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
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // points card
                  SizedBox(
                    width: 100,
                    child: Card(
                      color: Colors.yellow[100],

                      child: Padding(
                        padding:
                        const EdgeInsets.all(12),

                        child:
                        SingleChildScrollView(

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              const Text(
                                'Points',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                '(${dataset.points.length})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 12),

                              ...dataset.points
                                  .map((point) {

                                return Column(
                                  children: [

                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 6),

                                      child: Text(
                                        '(${point.x}, ${point.y})',
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

                  // scatterplot card
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.all(16),

                      child: ScatterChart(

                        ScatterChartData(

                          borderData:
                          FlBorderData(
                            show: true,
                          ),

                          gridData: FlGridData(
                            show: true,
                          ),

                          titlesData:
                          FlTitlesData(
                            show: true,
                          ),

                          scatterSpots:
                          dataset.points
                              .map((point) {

                            return ScatterSpot(
                              point.x,
                              point.y,
                            );

                          }).toList(),
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
                padding:
                const EdgeInsets.all(16),

                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,

                  children: [

                    Text(
                      dataset.regressionEquation,
                    ),

                    Text(
                      'Correlation: '
                          '${dataset.correlation.toStringAsFixed(2)}',
                    ),

                    Text(
                      'Covariance: '
                          '${dataset.covariance.toStringAsFixed(2)}',
                    ),


                    Text(
                      dataset.relationshipType,

                      style: TextStyle(
                        color: getRelationshipColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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