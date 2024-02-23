import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesState.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(SalesState()) {
    on<ShowOrderTypeOptions>(_onShowOrderTypeOptions);
  }

  Future<void> _onShowOrderTypeOptions(
      ShowOrderTypeOptions event, Emitter<SalesState> emit) async {
    emit(SalesState(showOrderTypeOptions: true));
  }
}
