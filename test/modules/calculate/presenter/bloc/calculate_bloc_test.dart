import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_result.dart';
import 'package:alugandoja/modules/calculate/domain/errors/errors.dart';
import 'package:alugandoja/modules/calculate/domain/usecases/calculate_usecase.dart';
import 'package:alugandoja/modules/calculate/presenter/bloc/calculate_bloc.dart';
import 'package:alugandoja/modules/calculate/presenter/events/calculate_events.dart';
import 'package:alugandoja/modules/calculate/presenter/states/calculate_states.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CalculateUsecaseMock extends Mock implements CalculateUsecase {}

final params = CalculationParams(
    residenceValue: 150000.98,
    expectedValue: 125000.87,
    bedroomsNumber: 3,
    region: 2);
void main() {
  final usecase = CalculateUsecaseMock();

  final bloc = CalculateBloc(usecase);

  group('Bloc', () {
    late CalculateBloc calculateBloc;

    setUp(() {
      calculateBloc = bloc;
    });

    test("Calculate - Deve retornar o estado inicial", () async {
      expect(calculateBloc.state, isA<CalculationStart>());
    });

    test(
        "Calculate - Deve retornar os estado na sequência correta em caso de sucesso",
        () async {
      when(() => usecase(params))
          .thenAnswer((_) async => Right(CalculationResult(
                minValue: 12,
                maxValue: 12,
                complementsText: "12",
              )));

      calculateBloc.add(Calculate(params));

      expectLater(
          calculateBloc.stream,
          emitsInOrder([
            isA<Calculating>(),
            isA<CalculateResult>(),
          ]));
    });

    test(
        "Calculate - Deve retornar os estado na sequência correta em caso de erro",
        () async {
      when(() => usecase(params))
          .thenAnswer((_) async => Left(CalculationError()));

      calculateBloc.add(Calculate(params));

      expectLater(
          calculateBloc.stream,
          emitsInOrder([
            isA<Calculating>(),
            isA<CalculateError>(),
          ]));
    });
  });
}
