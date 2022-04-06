import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';
import 'package:alugandoja/modules/calculate/domain/errors/errors.dart';
import 'package:alugandoja/modules/calculate/domain/repositories/interfaces/calculation_repository_interface.dart';
import 'package:alugandoja/modules/calculate/domain/usecases/calculate_usecase.dart';

class CalculationRepositoryMock extends Mock
    implements CalculationRepositoryInterface {}

void main() {
  final repository = CalculationRepositoryMock();
  final usecase = CalculateUsecase(repository);
  final params = CalculationParams(
      residenceValue: 150000.98,
      expectedValue: 125000.87,
      bedroomsNumber: 3,
      region: 2);
  test(
      'Calculate - Deve receber os parametros para cálculo e retornar um <CalculationResult>',
      () async {
    when(() => repository.calculate(params)).thenAnswer((_) async => Right(
        CalculationResult(
            minValue: 1200,
            maxValue: 1500,
            complementsText: "O Valor do seu aluguel deve ser de 1200.00")));

    final result = await usecase(params);
    expect(result.isRight(), true);
  });

  test(
      'Calculate - Deve receber os parametros para cálculo e retornar um <CalculationException>',
      () async {
    when(() => repository.calculate(params))
        .thenAnswer((_) async => Left(CalculationError()));

    final result = await usecase(params);
    expect(result.isLeft(), true);
  });
}
