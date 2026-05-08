import 'package:flutter/material.dart';
import '../models/dataset.dart';
import '../models/datasetpaired.dart';

class InputsPage extends StatefulWidget {

  final Function(Dataset) onAddDataset;
  final Function(PairedDataset) onAddPairedDataset;

  final List<Dataset> datasets;

  const InputsPage({
    super.key,
    required this.onAddDataset,
    required this.onAddPairedDataset,
    required this.datasets,
  });


  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {

  String? nameError;
  String? valuesError;
  String? yValuesError;


  bool isBivariate = false;

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController valuesController =
  TextEditingController();

  final TextEditingController yValuesController =
  TextEditingController();

  int getXCount() {

    return valuesController.text
        .split(',')
        .where((v) =>
    v.trim().isNotEmpty)
        .length;
  }

  int getYCount() {

    return yValuesController.text
        .split(',')
        .where((v) =>
    v.trim().isNotEmpty)
        .length;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [

          TextField(
            controller: nameController,

            onChanged: (value) {
              if (nameError != null) {
                setState(() {
                  nameError = null;
                });
              }
            },

            decoration: InputDecoration(
              labelText: "Dataset Name",

              errorText: nameError,

              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 16),

          Text(
            "Analysis Type",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text("Univariate"),
              ),
              ButtonSegment(
                value: true,
                label: Text("Bivariate"),
              ),
            ],
            selected: {isBivariate},
            onSelectionChanged: (selection) {
              setState(() {
                isBivariate = selection.first;
              });
            },
          ),

          Text(
            isBivariate
                ? 'Enter matching X and Y values separated by commas.'
                : 'Enter values separated by commas.',

            style: TextStyle(
              color: Colors.blueGrey[700],
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: valuesController,

            onChanged: (value) {
              if (valuesError != null) {
                setState(() {
                  valuesError = null;
                });
              }
            },

            decoration: InputDecoration(
              labelText: isBivariate ? "X Values" : "Values",
              hintText: "1, 2, 3, 4",

              errorText: valuesError,

              border: OutlineInputBorder(),
            ),
          ),

          if (isBivariate && valuesController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: 6,
                left: 4,
              ),

              child: Text(
                'X Count: ${getXCount()}',
                style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: 12,
                ),
              ),
            ),

          if (isBivariate) ...[
            const SizedBox(height: 16),

            TextField(
              controller: yValuesController,

              onChanged: (value) {
                if (yValuesError != null) {
                  setState(() {
                    yValuesError = null;
                  });
                }
              },

              decoration: InputDecoration(
                labelText: "Y Values",
                hintText: "3, 1, 4, 5",

                errorText: yValuesError,

                border: OutlineInputBorder(),
              ),
            ),

            if (isBivariate && yValuesController.text.isNotEmpty)

            Padding(
              padding: const EdgeInsets.only(
                top: 6,
                left: 4,
              ),

              child: Text(
                'Y Count: ${getYCount()}',
                style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: 12,
                ),
              ),
            ),
          ],

          SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              final alreadyExists = widget.datasets.any((d) => d.name.toLowerCase().trim() == nameController.text.toLowerCase().trim(),);

              if (nameController.text.trim().isEmpty) {
                setState(() {
                  nameError = "Please enter a dataset name";
                });
                return;
              }

              if (alreadyExists) {
                setState(() {
                  nameError = "Dataset already exists";
                });
                return;
              }

              if (valuesController.text.trim().isEmpty) {
                setState(() {
                  valuesError = "Please enter at least one value";
                });
                return;
              }


              final parsedValues = valuesController.text
                  .split(',')
                  .map((e) => double.tryParse(e.trim()))
                  .toList();

              if (parsedValues.contains(null)) {
                setState(() {
                  valuesError = "Invalid numeric input";
                });
                return;
              }

              final values = parsedValues.cast<double>();

              List<double> yValues = [];

              if (isBivariate) {

                if (yValuesController.text.trim().isEmpty) {
                  setState(() {
                    yValuesError =
                    "Please enter Y values";
                  });
                  return;
                }
                //Parse Y field
                final parsedYValues = yValuesController.text
                    .split(',')
                    .map((e) => double.tryParse(e.trim()))
                    .toList();

                if (parsedYValues.contains(null)) {
                  setState(() {
                    yValuesError =
                    "Invalid numeric input";
                  });
                  return;
                }

                yValues = parsedYValues.cast<double>();

                if (values.length != yValues.length) {
                  setState(() {
                    valuesError =
                    "Length of X and Y must match";
                    yValuesError =
                    "Length of X and Y must match";
                  });
                  return;
                }
              }
              //
              if (isBivariate) {
                //
                final points = List.generate(
                  values.length,
                      (index) => DataPoint(
                    x: values[index],
                    y: yValues[index],
                  ),
                );

                final newDataset = PairedDataset(
                  name: nameController.text,
                  points: points,
                );

                widget.onAddPairedDataset(
                    newDataset);

              } else {

                final newDataset = Dataset(
                  name: nameController.text,
                  values: values,
                );

                widget.onAddDataset(newDataset);
              }

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                SnackBar(
                  content: Text(
                    isBivariate
                        ? 'Bivariate dataset added'
                        : 'Dataset added',
                  ),

                  duration:
                  const Duration(seconds: 2),
                ),
              );
              //resets errors after successful submission
              setState(() {
                nameError = null;
                valuesError = null;
                yValuesError = null;
              });

              nameController.clear();
              valuesController.clear();
              yValuesController.clear();

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[100]
            ),
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}