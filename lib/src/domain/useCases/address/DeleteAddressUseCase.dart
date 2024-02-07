import 'package:ecommerce_flutter/src/domain/repositories/AddressRepository.dart';

class DeleteAddressUseCase {

  AddressRepository addressRepository;

  DeleteAddressUseCase(this.addressRepository);

  run(int id) => addressRepository.delete(id);

}