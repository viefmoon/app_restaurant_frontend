import 'package:app/src/presentation/pages/sales_receipts/sales/add_phone_number/bloc/AddPhoneNumberEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/add_phone_number/bloc/AddPhoneNumberState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AddPhoneNumberBloc
    extends Bloc<AddPhoneNumberEvent, AddPhoneNumberState> {
  AddPhoneNumberBloc()
      : super(AddPhoneNumberState(formKey: GlobalKey<FormState>())) {
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<PhoneNumberSubmitted>(_onPhoneNumberSubmitted);
  }

  void _onPhoneNumberChanged(
      PhoneNumberChanged event, Emitter<AddPhoneNumberState> emit) {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  void _onPhoneNumberSubmitted(
      PhoneNumberSubmitted event, Emitter<AddPhoneNumberState> emit) {
    // Aquí se manejaría la lógica para continuar con el número de teléfono ingresado o sin él
    print('Continuar con número de teléfono: ${state.phoneNumber}');
  }
}
