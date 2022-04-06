import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/domain/usecases/calculate_usecase.dart';
import 'package:alugandoja/modules/calculate/presenter/events/calculate_events.dart';
import 'package:alugandoja/modules/calculate/presenter/states/calculate_states.dart';
import 'package:bloc/bloc.dart';

class CalculateBloc extends Bloc<CalculateEvents, CalculateStates> {
  final CalculateUsecase usecase;
  CalculateBloc(this.usecase) : super(CalculationStart()) {
    on<Calculate>(_calculate);
    on<ResetResult>(_resetState);
  }

  _calculate(params, emit) async {
    emit(Calculating());
    final result = await usecase(params.params);
    result.fold(
      (failure) => emit(CalculateError()),
      (success) => emit(CalculateResult(success)),
    );
  }

  _resetState(params, emit) {
    emit(CalculationStart());
  }
}
