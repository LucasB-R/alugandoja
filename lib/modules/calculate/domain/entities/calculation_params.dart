import 'dart:convert';

class CalculationParams {
  final double residenceValue;
  final double? expectedValue;
  final int bedroomsNumber;
  final int region;

  CalculationParams(
      {required this.residenceValue,
      required this.bedroomsNumber,
      required this.region,
      this.expectedValue});

  Map<String, dynamic> toMap() {
    return {
      'residence_value': residenceValue,
      'expected_value': expectedValue,
      'bedrooms_number': bedroomsNumber,
      'region': region,
    };
  }

  String toJson() => json.encode(toMap());
}
