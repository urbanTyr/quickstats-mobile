//Nathaniel Jones (G01338189) - IT 315
//
//import material package and pages
import 'package:flutter/material.dart';
import 'pages/about.dart';
import 'pages/inputs.dart';
import 'pages/results.dart';
import 'models/dataset.dart';
import 'models/datasetpaired.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Stats',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: .fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const IamRootPage(),
    );
  }
}

class IamRootPage extends StatefulWidget {
  const IamRootPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  @override
  State<IamRootPage> createState() => _IamRootPageState();
}

class _IamRootPageState extends State<IamRootPage> {
  //Tracks the currently selected tab index
  int _currentIndex = 0;

  Future<File> _getFile() async {

    final directory =
    await getApplicationDocumentsDirectory();

    return File('${directory.path}/datasets.json');
  }

  Future<File> _getPairedFile() async {

    final directory =
    await getApplicationDocumentsDirectory();

    return File(
      '${directory.path}/paired_datasets.json',
    );
  }

  Future<void> saveDatasets() async {

    //debugPrint("Saving datasets...");

    final file = await _getFile();

    final jsonList = _datasets
        .map((dataset) => dataset.toJson())
        .toList();

    //debugPrint(jsonEncode(jsonList));

    await file.writeAsString(
      jsonEncode(jsonList),
    );
  }

  Future<void> savePairedDatasets()
  async {

    final file =
    await _getPairedFile();

    final jsonList =
    _pairedDatasets
        .map((dataset) =>
        dataset.toJson())
        .toList();

    await file.writeAsString(
      jsonEncode(jsonList),
    );
  }

  Future<void> loadDatasets() async {
    //debugPrint("Loading datasets...");
    try {

      final file = await _getFile();

      if (await file.exists()) {

        final contents =
        await file.readAsString();

        final List<dynamic> jsonData =
        jsonDecode(contents);
        //debugPrint(contents);
        setState(() {

          _datasets.clear();

          _datasets.addAll(

            jsonData.map(
                  (json) => Dataset.fromJson(json),
            ),

          );
        });
      }

    } catch (e) {

      debugPrint(
        'Error loading datasets: $e',
      );
    }
  }

  Future<void> loadPairedDatasets()
  async {

    try {

      final file =
      await _getPairedFile();

      if (await file.exists()) {

        final contents =
        await file.readAsString();

        final List<dynamic> jsonData =
        jsonDecode(contents);

        setState(() {

          _pairedDatasets.clear();

          _pairedDatasets.addAll(

            jsonData.map(
                  (json) =>
                  PairedDataset.fromJson(
                      json),
            ),
          );
        });
      }

    } catch (e) {

      debugPrint(
        'Error loading paired datasets: $e',
      );
    }
  }

  void addDataset(Dataset dataset) {

    setState(() {

      _datasets.add(dataset);

    });

    saveDatasets();
  }

  void addPairedDataset(
      PairedDataset dataset) {

    setState(() {
      _pairedDatasets.add(dataset);
    });

    savePairedDatasets();
  }

  void removeDataset(Dataset dataset) {

    setState(() {

      _datasets.remove(dataset);

    });

    saveDatasets();
  }

  void removePairedDataset(
      PairedDataset dataset) {

    setState(() {
      _pairedDatasets.remove(dataset);
    });

    savePairedDatasets();
  }

  final List<String> _titles = [
    "Results",
    "Inputs",
    "About",
  ];

  final List<Dataset> _datasets = [];
  final List<PairedDataset> _pairedDatasets = [];

  //List of pages used for NavigationBar tabs

  @override
  void initState() {

    super.initState();

    loadDatasets();
    loadPairedDatasets();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    final List<Widget> pages = [
      ResultsPage(
        datasets: _datasets,
        pairedDatasets:
        _pairedDatasets,
        onDeleteDataset:
          removeDataset,
        onDeletePairedDataset:
          removePairedDataset,
      ),
      InputsPage(
          onAddDataset: addDataset,
          onAddPairedDataset:
              addPairedDataset,
          datasets: _datasets,
      ),
      AboutPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _titles[_currentIndex],

        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        )),

        backgroundColor: Colors.blueGrey,

        foregroundColor: Colors.white60,
      ),

      body: pages[_currentIndex],
      //Bottom navigation bar to switch between app components
      bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.monitor_weight),
              label: 'Results',
            ),
            NavigationDestination(
              icon: Icon(Icons.calculate_sharp),
              label: 'Inputs',
            ),
            NavigationDestination(
                icon: Icon(Icons.question_mark),
                label: 'About',
            )
          ]
      ),
    );
  }
}
