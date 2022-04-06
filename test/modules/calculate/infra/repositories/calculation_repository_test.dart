import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';
import 'package:alugandoja/modules/calculate/infra/datasource/calculation_datasource.dart';
import 'package:alugandoja/modules/calculate/infra/repositories/calculation_repository.dart';

class CalculationDatasourceMock extends Mock implements CalculationDatasource {}

void main() {
  final datasource = CalculationDatasourceMock();
  final repository = CalculationRepository(datasource);

  final params = CalculationParams(
      residenceValue: 150000.98,
      expectedValue: 125000.87,
      bedroomsNumber: 3,
      region: 2);
  test(
      'Calculation - Deve calcular com sucesso a partir do repositório e retornar um <CalculationResult>',
      () async {
    when(() => datasource.calculate(params)).thenAnswer((_) async =>
        CalculationResult(
            minValue: 1200,
            maxValue: 1500,
            complementsText: "O Valor do seu aluguel deve ser de 1200.00"));

    final result = await repository.calculate(params);
    expect(result.isRight(), true);
  });

  test(
      'Calculation - Deve retornar um <CalculationException> caso o datasource retorne um <Exception>',
      () async {
    when(() => datasource.calculate(params)).thenThrow(Exception());

    final result = await repository.calculate(params);
    expect(result.isLeft(), true);
  });
}
