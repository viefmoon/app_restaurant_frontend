import 'package:ecommerce_flutter/src/domain/repositories/ShoppingBagRepository.dart';

class GetTotalShoppingBagUseCase {

  ShoppingBagRepository shoppingBagRepository;

  GetTotalShoppingBagUseCase(this.shoppingBagRepository);

  run() => shoppingBagRepository.getTotal();

}