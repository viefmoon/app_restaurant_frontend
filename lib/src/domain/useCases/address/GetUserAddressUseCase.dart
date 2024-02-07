import 'package:ecommerce_flutter/src/domain/repositories/AddressRepository.dart';

class GetUserAddressUseCase {

  AddressRepository addressRepository;

  GetUserAddressUseCase(this.addressRepository);

  run(int idUser) => addressRepository.getUserAddress(idUser);

}