import 'package:ecommerce_flutter/src/domain/repositories/AddressRepository.dart';

class DeleteAddressFromSessionUseCase {

  AddressRepository addressRepository;

  DeleteAddressFromSessionUseCase(this.addressRepository);

  run() => addressRepository.deleteFromSession();

}