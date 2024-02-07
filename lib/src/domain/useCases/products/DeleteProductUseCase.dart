import 'package:ecommerce_flutter/src/domain/repositories/ProductsRepository.dart';

class DeleteProductUseCase {

  ProductsRepository productsRepository;

  DeleteProductUseCase(this.productsRepository);

  run(int id) =>  productsRepository.delete(id);

}