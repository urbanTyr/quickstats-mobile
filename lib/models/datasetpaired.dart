import '../models/dataset.dart';

class DataPoint {
  final double x;
  final double y;

  DataPoint({
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  factory DataPoint.fromJson(
      Map<String, dynamic> json) {

    return DataPoint(
      x: json['x'],
      y: json['y'],
    );
  }
}

class PairedDataset {
  final String name;

  final List<DataPoint> points;

  PairedDataset({
    required this.name,
    required this.points,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,

      'points':
      points.map((p) =>
          p.toJson()).toList(),
    };
  }

  factory PairedDataset.fromJson(
      Map<String, dynamic> json) {

    return PairedDataset(
      name: json['name'],

      points:
      (json['points'] as List)
          .map((point) {

        return DataPoint.fromJson(point);

      }).toList(),
    );
  }

  Dataset get xDataset => Dataset(
    name: 'X Values',
    values: points.map((p) => p.x).toList(),
  );

  Dataset get yDataset => Dataset(
    name: 'Y Values',
    values: points.map((p) => p.y).toList(),
  );

  double get correlation {
    //Gets the mean of X and Y datasets
    final xMean = xDataset.mean;
    final yMean = yDataset.mean;
    //Tracks the summed products of deviations from the mean
    double numerator = 0;
    //loops through all paired points
    for (int i = 0; i < points.length; i++) {

      numerator +=
          (points[i].x - xMean) *
              (points[i].y - yMean);
    }
    //calculates the denominator using standard deviations of X and Y
    final denominator =
        points.length *
            xDataset.standardDeviation *
            yDataset.standardDeviation;
    //Prevents division by zero
    if (denominator == 0) {
      return 0;
    }
    //Returns Pearson based correlation coefficient
    return numerator / denominator;
  }

  double get covariance {
    //gets the mean of X and Y datasets
    final xMean = xDataset.mean;
    final yMean = yDataset.mean;
    //Tracks summed products of deviations
    double sum = 0;
    //Loops through paired points
    for (int i = 0; i < points.length; i++) {
      sum +=
          (points[i].x - xMean) *
              (points[i].y - yMean);
    }
    //Returns sample covariance
    return sum / (points.length - 1);
  }
  //slope formula
  double get slope {

    return correlation *
        (yDataset.standardDeviation /
            xDataset.standardDeviation);
  }
  //intercept formula
  double get intercept {

    return yDataset.mean -
        (slope * xDataset.mean);
  }
  //regression line
  String get regressionEquation {

    final sign =
    intercept >= 0 ? '+' : '-';

    return
      'y = '
          '${slope.toStringAsFixed(2)}x '
          '$sign '
          '${intercept.abs().toStringAsFixed(2)}';
  }
  //qualitative correlation determination
  String get relationshipType {

    final r = correlation.abs();

    if (r >= 0.9) {
      return correlation > 0
          ? 'Very Strong Positive'
          : 'Very Strong Negative';
    }

    if (r >= 0.7) {
      return correlation > 0
          ? 'Strong Positive'
          : 'Strong Negative';
    }

    if (r >= 0.5) {
      return correlation > 0
          ? 'Moderate Positive'
          : 'Moderate Negative';
    }

    if (r >= 0.3) {
      return correlation > 0
          ? 'Weak Positive'
          : 'Weak Negative';
    }

    return 'Little or No Correlation';
  }
}

