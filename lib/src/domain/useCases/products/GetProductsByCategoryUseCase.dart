import 'package:ecommerce_flutter/src/domain/repositories/ProductsRepository.dart';

class GetProductsByCategoryUseCase {

  ProductsRepository productsRepository;

  GetProductsByCategoryUseCase(this.productsRepository);

  run(int idCategory) => productsRepository.getProductsByCategory(idCategory);

}