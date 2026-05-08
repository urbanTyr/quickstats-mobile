import 'package:flutter/material.dart';
import '../models/dataset.dart';
import '../models/datasetpaired.dart';
import 'details.dart';
import 'detailspaired.dart';

class ResultsPage extends StatelessWidget {
  final List<Dataset> datasets;
  final List<PairedDataset> pairedDatasets;

  final Function(Dataset) onDeleteDataset;
  final Function(PairedDataset) onDeletePairedDataset;

  const ResultsPage({
    super.key,
    required this.datasets,
    required this.onDeleteDataset,
    required this.pairedDatasets,
    required this.onDeletePairedDataset,
  });

  @override
  Widget build(BuildContext context) {
    //checks if there are any datasets loaded, if not, prompts user to input one
    if (datasets.isEmpty && pairedDatasets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.bar_chart,
              size: 64,
              color: Colors.blueGrey,
            ),

            SizedBox(height: 16),

            Text(
              'No datasets yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Add a dataset in the Inputs tab.',
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [

        // univariate datasets
        ...datasets.asMap().entries.map((entry) {

          final index = entry.key;
          final dataset = entry.value;

          return Card(
            color: index.isEven
                ? Colors.blue[100]
                : Colors.grey[200],

            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            elevation: 3,

            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsPage(
                      dataset: dataset,
                    ),
                  ),
                );
              },

              title: Text(
                dataset.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Padding(
                padding:
                const EdgeInsets.only(top: 8),

                child: Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Mean: ${dataset.mean.toStringAsFixed(2)}',
                    ),

                    Text(
                      'Median: ${dataset.median.toStringAsFixed(2)}',
                    ),

                    Text(
                      'Std Dev: ${dataset.standardDeviation.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),

              trailing: IconButton(
                icon: const Icon(Icons.delete),

                onPressed: () {
                  onDeleteDataset(dataset);
                },
              ),
            ),
          );
        }),

        // paired datasets
        ...pairedDatasets
            .asMap()
            .entries
            .map((entry) {

    final index = entry.key;
    final dataset = entry.value;

          return Card(
          color: index.isEven
          ? Colors.blue[100]
              : Colors.grey[200],

            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            elevation: 3,

            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailsPairedPage(
                          dataset: dataset,
                        ),
                  ),
                );
              },

              leading: const Icon(
                Icons.multiple_stop,
                color: Colors.green,
              ),

              title: Text(
                dataset.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),

                child: Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [

                    Text(
                      'Correlation: '
                          '${dataset.correlation.toStringAsFixed(2)}',
                    ),

                    Text(
                      'Covariance: '
                          '${dataset.covariance.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),

                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                        const Text(
                            "Delete Dataset"),

                        content: Text(
                          'Delete "${dataset.name}"?',
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            child: const Text(
                                "Cancel"),
                          ),

                          TextButton(
                            onPressed: () {

                              onDeletePairedDataset(
                                  dataset);

                              Navigator.pop(context);
                            },

                            child:
                            const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
