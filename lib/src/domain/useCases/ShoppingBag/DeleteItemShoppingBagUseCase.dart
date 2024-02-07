import 'package:ecommerce_flutter/src/domain/models/Product.dart';
import 'package:ecommerce_flutter/src/domain/repositories/ShoppingBagRepository.dart';

class DeleteItemShoppinBagUseCase {

  ShoppingBagRepository shoppingBagRepository;

  DeleteItemShoppinBagUseCase(this.shoppingBagRepository);

  run(Product product) => shoppingBagRepository.deleteItem(product);

}