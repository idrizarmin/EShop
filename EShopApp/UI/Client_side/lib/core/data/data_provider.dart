import 'package:e_commerce_flutter/screen/login_screen/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/category.dart';
import '../../models/api_response.dart';
import '../../models/brand.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/sub_category.dart';
import '../../models/user.dart';
import '../../services/http_services.dart';
import '../../utility/constants.dart';
import '../../utility/snack_bar_helper.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();


  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  DataProvider() {
    getAllProducts();
    getAllCategory();
    getAllSubCategory();
    getAllBrands();
    getAllPosters();
  }

  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'categories');
      if (response.isOk) {
        ApiResponse<List<Category>> apiResponse =
            ApiResponse<List<Category>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Category.fromJson(item))
                    .toList());
        _allCategories = apiResponse.data ?? [];

        // Replace 'localhost' with 'http://10.0.2.2:3000' in image
        for (var category in _allCategories) {
          if (category.image!.contains('localhost')) {
            category.image =
                category.image!.replaceAll('localhost', '10.0.2.2');
          }
        }

        _filteredCategories = List.from(_allCategories);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCategories;
  }

  void filterCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<SubCategory>> getAllSubCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'subCategories');
      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse =
            ApiResponse<List<SubCategory>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => SubCategory.fromJson(item))
                    .toList());
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(_allSubCategories);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredSubCategories;
  }

  void filterSubCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredSubCategories = _allSubCategories.where((subCategory) {
        return (subCategory.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Brand>> getAllBrands({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'brands');
      if (response.isOk) {
        ApiResponse<List<Brand>> apiResponse =
            ApiResponse<List<Brand>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Brand.fromJson(item))
                    .toList());
        _allBrands = apiResponse.data ?? [];
        _filteredBrands = List.from(_allBrands);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _allBrands;
  }

  void filterBrands(String keyword) {
    if (keyword.isEmpty) {
      _filteredBrands = List.from(_allBrands);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredBrands = _allBrands.where((brand) {
        return (brand.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

 Future<List<Product>> getAllProducts({bool showSnack = false}) async {
  try {
    Response response = await service.getItems(endpointUrl: 'products');
    if (response.isOk) {
      ApiResponse<List<Product>> apiResponse = ApiResponse<List<Product>>.fromJson(
        response.body,
        (json) => (json as List).map((item) => Product.fromJson(item)).toList()
      );
      _allProducts = apiResponse.data ?? [];

      // Replace 'localhost' with 'http://10.0.2.2:3000' in all image URLs
      for (var product in _allProducts) {
        if (product.images != null) {
          for (var image in product.images!) {
            if (image.url!.contains('localhost')) {
              image.url = image.url!.replaceAll('localhost', '10.0.2.2');
            }
          }
        }
      }

      _filteredProducts = List.from(_allProducts);
      notifyListeners();
      if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
    }
  } catch (e) {
    if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
    rethrow;
  }
  return _allProducts;
}

  void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowerKeyword = keyword.toLowerCase();

      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyword =
            (product.name ?? '').toLowerCase().contains(lowerKeyword);
        final categoryNameContainsKeyword =
            product.proCategoryId?.name?.toLowerCase().contains(lowerKeyword) ??
                false;
        final subCategoryNameContainsKeyword = product.proSubCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyword) ??
            false;

        return productNameContainsKeyword ||
            categoryNameContainsKeyword ||
            subCategoryNameContainsKeyword;
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');
      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse =
            ApiResponse<List<Poster>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Poster.fromJson(item))
                    .toList());

        _allPosters = apiResponse.data ?? [];

        // Replace 'localhost' with 'http://10.0.2.2:3000' in imageUrl
        for (var poster in _allPosters) {
          if (poster.imageUrl!.contains('localhost')) {
            poster.imageUrl =
                poster.imageUrl!.replaceAll('localhost', '10.0.2.2');
          }
        }

        _filteredPosters = List.from(_allPosters);
        notifyListeners();

        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredPosters;
  }

  Future<List<Order>> getAllOrders({bool showSnack = false}) async {
    try {
      

      Response response = await service.getItems(endpointUrl: 'orders');
      if (response.isOk) {
        ApiResponse<List<Order>> apiResponse =
            ApiResponse<List<Order>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Order.fromJson(item))
                    .toList());
        _allOrders = apiResponse.data ?? [];
        _filteredOrders = List.from(_allOrders);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _allOrders;
  }


  void setFilteredOrders(List<Order> orders) {
    _filteredOrders = List.from(orders);
    notifyListeners();
  }
//   Future<List<Order>> getAllOrdersByUserId({bool showSnack = false}) async {
//   try {
   

//     Response response = await service.getItems(endpointUrl: 'orders/orderByUserId/6674120ba94798996a5f5ff4');
//     if (response.isOk) {
//       ApiResponse<List<Order>> apiResponse =
//           ApiResponse<List<Order>>.fromJson(
//               response.body,
//               (json) => (json as List)
//                   .map((item) => Order.fromJson(item))
//                   .toList());
//       _allOrders = apiResponse.data ?? [];
//       _filteredOrders = List.from(_allOrders);
//       notifyListeners();
//       if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
//     }
//   } catch (e) {
//     if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
//     rethrow;
//   }
//   return _allOrders;
// }


  double calculateDiscountPercentage(num originalPrice, num? discountedPrice) {
    if (originalPrice <= 0) {
      throw ArgumentError('Original price must be greater than zero.');
    }

    //? Ensure discountedPrice is not null; if it is, default to the original price (no discount)
    num finalDiscountedPrice = discountedPrice ?? originalPrice;

    if (finalDiscountedPrice > originalPrice) {
      return originalPrice.toDouble();
    }

    double discount =
        ((originalPrice - finalDiscountedPrice) / originalPrice) * 100;

    //? Return the discount percentage as an integer
    return discount;
  }
}
