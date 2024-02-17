import 'package:app/src/presentation/utils/BlocFormItem.dart';
import 'package:equatable/equatable.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object> get props => [];
}

class ShowOrderTypeOptions extends SalesEvent {
  const ShowOrderTypeOptions();
}

class SelectOrderTypeOption extends SalesEvent {
  final String option;

  const SelectOrderTypeOption(this.option);

  @override
  List<Object> get props => [option];
}

class PhoneNumberChanged extends SalesEvent {
  final BlocFormItem phoneNumber;
  const PhoneNumberChanged({required this.phoneNumber});
  @override
  List<Object> get props => [phoneNumber];
}

class SalesSubmit extends SalesEvent {
  const SalesSubmit();
}
