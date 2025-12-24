// lib/presentation/controllers/product_controller.dart
import 'package:get/get.dart';
import 'package:leave_management/domain/entities/product_entity.dart';
import 'package:leave_management/domain/usecases/get_products_usecase.dart';

class ProductController extends GetxController {
  final GetProductsUsecase getProductsUsecase;
  var isLoading = false.obs;
  var products = <ProductEntity>[].obs;

  ProductController(this.getProductsUsecase);

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final productList = await getProductsUsecase.call();
      products.value = productList;
    } finally {
      isLoading.value = false;
    }
  }
}
