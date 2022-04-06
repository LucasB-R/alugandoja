import 'package:flutter_test/flutter_test.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/internal/calculation.dart';

void main() {
  final calculation = Calculation();
  final params = CalculationParams(
      residenceValue: 150000.98,
      expectedValue: 125000.87,
      bedroomsNumber: 3,
      region: 2);

  final paramsInvalidRegion = CalculationParams(
      residenceValue: 150000.98,
      expectedValue: 125000.87,
      bedroomsNumber: 3,
      region: 4444);
  test(
      'Calculation - Deve enviar <CalculationParams> e receber um <CalculationResult> do internal',
      () async {
    final result = calculation.calculate(params);
    expect(result, completes);
  });
  test(
      'Calculation - Deve enviar <CalculationParams> e receber um <Exception> do internal caso não encontre a região.',
      () async {
    final result = calculation.calculate(paramsInvalidRegion);
    expect(result, throwsA(isA<Exception>()));
  });
}
