import 'package:equatable/equatable.dart';

abstract class AddPhoneNumberEvent extends Equatable {
  const AddPhoneNumberEvent();
}

class PhoneNumberChanged extends AddPhoneNumberEvent {
  final String phoneNumber;

  const PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneNumberSubmitted extends AddPhoneNumberEvent {
  const PhoneNumberSubmitted();

  @override
  List<Object> get props => [];
}
