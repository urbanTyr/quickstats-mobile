import 'dart:math';

class Dataset {

  final String name;
  final List<double> values;

  Dataset({
    required this.name,
    required this.values,
  });

  bool get isEmpty => values.isEmpty;

  // helper function to sort data values
  List<double> get sortedValues {
    final sorted = [...values];
    sorted.sort();
    return sorted;
  }
  // helper function to return a median from
  double _calculateMedian(List<double> numbers) {

    if (numbers.isEmpty) return 0;

    final sorted = [...numbers];
    sorted.sort();

    int middle = sorted.length ~/ 2;

    if (sorted.length.isOdd) {
      return sorted[middle];
    } else {
      return (
          sorted[middle - 1] + sorted[middle]
      ) / 2;
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'values': values,
    };
  }

  factory Dataset.fromJson(Map<String, dynamic> json) {
    return Dataset(
      name: json['name'],
      values: List<double>.from(json['values']),
    );
  }

  double get mean {

    if (isEmpty) return 0;

    return values.reduce((a, b) => a + b) / values.length;
  }


  double get standardDeviation {

    if (isEmpty) return 0;

    final avg = mean;

   final squaredDifferences = values.map((value) {
     return pow(value - avg, 2).toDouble();
   }).toList();

    final variance = squaredDifferences.reduce((a, b) => a + b) /values.length;

    return sqrt(variance);
  }

  double get median => _calculateMedian(sortedValues);

  double get min => isEmpty ? 0 : sortedValues.first;

  double get max => isEmpty ? 0 : sortedValues.last;

  double get range => max - min;

  double get q1 {
    final sorted = sortedValues;

    int middle = sorted.length ~/ 2;

    final lowerHalf = sorted.sublist(0, middle);

    return _calculateMedian(lowerHalf);
  }

  double get q3 {
    final sorted = sortedValues;

    int middle = sorted.length ~/ 2;

    final upperHalf = sorted.length.isOdd
        ? sorted.sublist(middle + 1)
        : sorted.sublist(middle);

    return _calculateMedian(upperHalf);
  }
  double get iqr => q3 - q1;
}