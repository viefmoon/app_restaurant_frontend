import 'package:ecommerce_flutter/src/domain/repositories/ShoppingBagRepository.dart';

class deleteShoppingBagUseCase {
  ShoppingBagRepository shoppingBagRepository;

  deleteShoppingBagUseCase(this.shoppingBagRepository);

  run() => shoppingBagRepository.deleteShoppingBag();
}