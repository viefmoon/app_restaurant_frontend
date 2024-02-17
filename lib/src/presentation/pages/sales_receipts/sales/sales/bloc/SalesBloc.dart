import 'package:app/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesState.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(SalesState()) {
    on<ShowOrderTypeOptions>(_onShowOrderTypeOptions);
    on<SelectOrderTypeOption>(_onSelectOrderTypeOption);
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<SalesSubmit>(_onSalesOrder);
  }

  Future<void> _onShowOrderTypeOptions(
      ShowOrderTypeOptions event, Emitter<SalesState> emit) async {
    print('ShowOrderTypeOptions');
    print(event);
    emit(SalesState(showOrderTypeOptions: true));
  }

  Future<void> _onSelectOrderTypeOption(
      SelectOrderTypeOption event, Emitter<SalesState> emit) async {
    emit(SalesState(
      showOrderTypeOptions: true,
      selectedOrderTypeOption: event.option,
    ));
  }

  Future<void> _onPhoneNumberChanged(
      PhoneNumberChanged event, Emitter<SalesState> emit) async {
    emit(state.copyWith(
        phoneNumber: BlocFormItem(
            value: event.phoneNumber.value,
            error: event.phoneNumber.value.isNotEmpty &&
                    event.phoneNumber.value.length >= 10
                ? null
                : 'Ingresa un número válido')));
  }

  Future<void> _onSalesOrder(
      SalesSubmit event, Emitter<SalesState> emit) async {
    // Aquí iría la lógica para manejar el envío del pedido
    // Por ejemplo, podrías cambiar el estado a un estado de "envío exitoso"
    // o manejar la lógica para guardar el pedido en una base de datos
  }
}
