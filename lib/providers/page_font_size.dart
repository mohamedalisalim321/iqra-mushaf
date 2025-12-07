import 'package:flutter/material.dart';

/// Screen size categories
enum ScreenType { small, medium, large }

/// Determine screen type based on width
ScreenType getScreenType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 360) return ScreenType.small;
  if (width < 600) return ScreenType.medium;
  return ScreenType.large;
}

/// ===========================================================================
/// FONT SIZE RULES
/// ===========================================================================

/// Map of index → fontSize to avoid long `if` chains
const Map<Set<int>, double> _specialFontSizes = {
  {1, 2}: 25.0,
  {145, 585}: 22.7,
  {532, 533, 523, 577}: 22.5,
  {116, 156}: 23.4,
  {
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
  }: 23.0, // grouped 23
  {70}: 23.5,
  {51, 501}: 23.7,
  {581, 575}: 23.0, // same as 23
  {51, 576, 567, 577, 371, 446, 447}: 22.8,
};

/// Optional: single-entry overrides for clarity
const Map<int, double> _singleOverrides = {
  568: 23.1, // you explicitly mentioned this as special
};

/// Finds a matching font size from maps
double? _getSpecialFontSize(int index) {
  // quick check for direct override
  if (_singleOverrides.containsKey(index)) {
    return _singleOverrides[index];
  }

  // loop through rule sets
  for (final entry in _specialFontSizes.entries) {
    if (entry.key.contains(index)) return entry.value;
  }

  return null;
}

/// ===========================================================================
/// MAIN GET FONT SIZE FUNCTION
/// ===========================================================================

double getFontSize(int index, BuildContext context) {
  final orientation = MediaQuery.of(context).orientation;

  // landscape fixed
  if (orientation != Orientation.portrait) {
    return 35.0;
  }

  // screen-size base values
  final screenType = getScreenType(context);

  switch (screenType) {
    case ScreenType.large:
      return 15.0;
    case ScreenType.small:
      return 20.0;
    case ScreenType.medium:
      // medium → proceed to index-based logic
      break;
  }

  // SPECIAL CASE LOOKUP
  final special = _getSpecialFontSize(index);
  if (special != null) return special;

  // DEFAULT FONT SIZE
  return 23.1;
}
