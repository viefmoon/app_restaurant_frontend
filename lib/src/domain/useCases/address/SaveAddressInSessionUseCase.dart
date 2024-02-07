import 'package:ecommerce_flutter/src/domain/models/Address.dart';
import 'package:ecommerce_flutter/src/domain/repositories/AddressRepository.dart';

class SaveAddressInSessionUseCase {

  AddressRepository addressRepository;

  SaveAddressInSessionUseCase(this.addressRepository);

  run(Address address) => addressRepository.saveAddressInSession(address);

}