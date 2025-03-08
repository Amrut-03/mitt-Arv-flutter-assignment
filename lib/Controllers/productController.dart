import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  var productList = <dynamic>[].obs;
  var isLoading = false.obs;
  var cartproduct = {}.obs; // Holds single product details
  var cart = <Map<String, dynamic>>[].obs; // Holds cart items
  var product = Rxn<Map<String, dynamic>>();
  var filteredProductList = <dynamic>[].obs;
  var searchQuery = ''.obs;
  Timer? _debounce;
  var selectedSortOption = ''.obs;
  var selectedCategories = <String>[].obs;
  var minPrice = ''.obs;
  var maxPrice = ''.obs;
  var minRating = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllProducts();
  }

  Future<void> getAllProducts() async {
    try {
      isLoading.value = true;
      var response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        productList.value = json.decode(response.body);
      } else {
        Get.snackbar("Error", "Failed to load products");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSingleProduct(int id) async {
    try {
      var response = await http.get(
        Uri.parse('https://fakestoreapi.com/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        product.value = jsonDecode(response.body);
      } else {
        log("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Exception: $e");
    }
  }

  void sortProducts(String sortBy) {
    selectedSortOption.value = sortBy;

    List<dynamic> sortingList =
        filteredProductList.isEmpty ? productList : filteredProductList;

    switch (sortBy) {
      case 'Price: Low to High':
        sortingList
            .sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
        break;
      case 'Price: High to Low':
        sortingList
            .sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
        break;
      case 'Rating: High to Low':
        sortingList.sort((a, b) =>
            (b['rating']['rate'] as num).compareTo(a['rating']['rate'] as num));
        break;
      case 'Buyer Count: High to Low':
        sortingList.sort((a, b) => (b['rating']['count'] as num)
            .compareTo(a['rating']['count'] as num));
        break;
      default:
        break;
    }

    filteredProductList.assignAll(sortingList);
    filteredProductList.refresh();
  }

  void applyFilters() {
    log("Applying Filters...");
    log("Selected Categories: $selectedCategories");
    log("Min Price: $minPrice, Max Price: $maxPrice, Min Rating: $minRating");

    double minPriceValue = double.tryParse(minPrice.value) ?? 0;
    double maxPriceValue = double.tryParse(maxPrice.value) ?? double.infinity;
    double minRatingValue = double.tryParse(minRating.value) ?? 0;

    filteredProductList.value = productList.where((product) {
      bool matchesSearch = searchQuery.value.isEmpty ||
          product["title"]
              .toString()
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      bool matchesCategory = selectedCategories.isEmpty ||
          selectedCategories.contains(product["category"]);

      bool matchesPrice = product["price"] >= minPriceValue &&
          product["price"] <= maxPriceValue;

      bool matchesRating = product["rating"]["rate"] >= minRatingValue;

      return matchesSearch && matchesCategory && matchesPrice && matchesRating;
    }).toList();

    log("Filtered Products Count: ${filteredProductList.length}");

    filteredProductList.refresh();

    if (selectedSortOption.isNotEmpty) {
      sortProducts(selectedSortOption.value);
    }
  }

  void resetFilters() {
    selectedCategories.clear();
    minPrice.value = '';
    maxPrice.value = '';
    minRating.value = '';
    searchQuery.value = "";

    filteredProductList.assignAll(productList);
    filteredProductList.refresh();
  }

  List<dynamic> get filteredProducts {
    if (filteredProductList.isNotEmpty) {
      return filteredProductList;
    } else if (searchQuery.value.isNotEmpty) {
      return productList
          .where((product) => product["title"]
              .toString()
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    } else {
      return productList;
    }
  }

  void updateSearchQuery(String query) {
    // Cancel previous debounce timer if running
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Start a new debounce timer (500ms delay)
    _debounce = Timer(Duration(milliseconds: 500), () {
      searchQuery.value = query;
    });
  }

  void addToCart(Map<String, dynamic> product) {
    int index = cart.indexWhere((item) => item['id'] == product['id']);
    if (index != -1) {
      // If product exists, increase quantity
      cart[index]['quantity'] += 1;
      cart[index]['totalPrice'] =
          cart[index]['quantity'] * cart[index]['price'];
      cart.refresh();
    } else {
      // Add new product with quantity 1
      cart.add({
        'id': product['id'],
        'title': product['title'],
        'price': product['price'],
        'image': product['image'], // Ensure image is stored
        'quantity': 1,
        'totalPrice': product['price'],
      });
      cart.refresh();
    }
    Get.snackbar("Added to Cart", "${product['title']} added!");
  }

  void removeFromCart(int id) {
    int index = cart.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      if (cart[index]['quantity'] > 1) {
        // Reduce quantity
        cart[index]['quantity'] -= 1;
        cart[index]['totalPrice'] =
            cart[index]['quantity'] * cart[index]['price'];
      } else {
        // Remove item from cart if quantity is 1
        cart.removeAt(index);
      }
      cart.refresh();
    }
  }

  // Get total price
  double get totalCartPrice =>
      cart.fold(0, (sum, item) => sum + item['totalPrice']);
}
