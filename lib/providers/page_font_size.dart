import 'package:flutter/material.dart';

enum ScreenType { small, medium, large }

ScreenType getScreenType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 360) return ScreenType.small;
  if (width < 600) return ScreenType.medium;
  return ScreenType.large;
}

// Lookup sets for cleaner checks
const Set<int> index23 = {
  56,
  57,
  368,
  269,
  372,
  376,
  409,
  435,
  444,
  448,
  527,
  535,
  565,
  566,
  569,
  574,
  578,
  581,
  584,
  587,
  589,
  590,
  592,
  593,
  50,
  568,
  34
};

const Set<int> index22_5 = {532, 533, 523, 577};
const Set<int> index22_7 = {145, 585};
const Set<int> index23_4 = {116, 156};
const Set<int> index23_7 = {51, 501};
const Set<int> index23_5 = {70};
const Set<int> index23Special = {581, 575};
const Set<int> index22_8 = {576, 567, 577, 371, 446, 447};

double getFontSize(int index, BuildContext context) {
  final orientation = MediaQuery.of(context).orientation;
  final screenType = getScreenType(context);

  // ORIENTATION CHECK
  if (orientation != Orientation.portrait) {
    return 35;
  }

  // SCREEN SIZE CHECKS
  if (screenType == ScreenType.large) return 15;
  if (screenType == ScreenType.small) return 20;

  // INDEX-BASED SPECIAL CASES
  if (index == 1 || index == 2) return 25;
  if (index22_7.contains(index)) return 22.7;
  if (index22_5.contains(index)) return 22.5;
  if (index23_4.contains(index)) return 23.4;
  if (index23.contains(index)) return 23;
  if (index == 568) return 23.1; // keeps your extra special case
  if (index23_5.contains(index)) return 23.5;
  if (index23_7.contains(index)) return 23.7;
  if (index23Special.contains(index)) return 23;
  if (index22_8.contains(index)) return 22.8;

  return 23.1; // DEFAULT
}
