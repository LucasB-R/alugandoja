import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alugandoja/modules/calculate/di/calculate_module.dart';
import 'package:alugandoja/modules/calculate/domain/usecases/calculate_usecase.dart';
import 'package:alugandoja/modules/calculate/domain/usecases/interfaces/calculate_interface.dart';

void main() {
  Modular.init(CalculateModule());

  test('Calculate - Deve recuperar o Usecase', () {
    final usecase = Modular.get<CalculateInterface>();
    expect(usecase, isA<CalculateUsecase>());
  });
}
