QuickStats
A Flutter application for descriptive statistics, correlation, and linear regression.
QuickStats is a mobile-oriented statistical analysis application written in Dart with Flutter. It lets users enter numerical datasets, calculate descriptive statistics, explore relationships between paired variables, and visualize results. The project was developed for IT 315 at George Mason University.
The goal is to make common statistical calculations accessible through a straightforward graphical interface while implementing the underlying calculations directly in Dart.
Features
Single-variable analysis
Create and save named numerical datasets and calculate:
- Mean and median
- Minimum, maximum, and range
- Population standard deviation
- First and third quartiles (Q1 and Q3)
- Interquartile range (IQR)
A dataset detail screen displays individual values, summary statistics, and a line chart showing the values in their entered order.
Paired-variable analysis
Enter paired (x, y) observations to calculate:
- Pearson correlation coefficient (r)
- Sample covariance
- Least-squares linear regression slope and intercept
- Regression equation in the form y = mx + b
- A qualitative description of correlation strength and direction
Paired-data results include a scatterplot and the calculated relationship statistics.
Dataset management
- Create and remove named single-variable and paired-variable datasets
- Review results in separate summary and detail screens
- Save datasets locally as JSON files and reload them on startup
- Navigate between Results, Inputs, and About screens
Tech stack
Component	Technology
Application framework	Flutter
Programming language	Dart
Interface	Flutter Material widgets
Visualization	fl_chart
Local storage	JSON files through path_provider and dart:io
Data modeling	Custom Dataset, DataPoint, and PairedDataset classes


Project structure
lib/
├── main.dart                  # App setup, navigation, and local persistence
├── models/
│   ├── dataset.dart           # Descriptive statistics for a single variable
│   └── datasetpaired.dart     # Correlation, covariance, and regression
└── pages/
    ├── inputs.dart           # Data entry
    ├── results.dart          # Saved dataset summaries
    ├── details.dart          # Single-variable statistics and line chart
    ├── detailspaired.dart    # Paired-data statistics and scatterplot
    └── about.dart            # About screen
Run locally
You'll need a Flutter SDK compatible with this project's Dart SDK constraint (^3.10.8) and a configured Flutter development environment.
git clone https://github.com/urbanTyr/quickstats-mobile.git
cd quickstats-mobile
flutter pub get
flutter run
To see configured devices, run flutter devices. Platform support depends on your local Flutter setup. The code uses dart:io for local file storage, so browser compatibility should not be assumed without additional adaptation.
Statistical implementation notes
The statistical calculations live in the model classes rather than being delegated to an external statistics library:
- Standard deviation uses the population formula (variance divided by n).
- Covariance uses the sample formula (sum of cross-deviations divided by n - 1).
- Pearson correlation is calculated from centered paired observations and the variables' standard deviations.
- Linear regression calculates a slope from correlation and the ratio of standard deviations, then obtains the intercept from the variable means.
- Quartiles are calculated as the medians of the lower and upper halves of the sorted data, excluding the overall median when the dataset contains an odd number of observations.
Limitations: This is a course project, not a validated statistical package. Some edge cases, particularly datasets with too few points or no variation in one variable, need additional input validation and handling. The current implementation returns 0 for correlation when its denominator is zero, which should not be interpreted as a statistically defined correlation in those cases.
Background
QuickStats was built as a software development project combining numerical computation, data modeling, persistent storage, and interactive visualization. Although it is a general-purpose statistics app rather than a bioinformatics tool, the underlying skills in quantitative computing and structured data analysis are transferable to scientific and biological data applications.
Author
Nathaniel Jones
BS Information Technology, George Mason University
GitHub: urbanTyr
