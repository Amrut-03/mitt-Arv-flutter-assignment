import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mitt_arv_e_commerce_app/Controllers/cartController.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';

class ProductController extends GetxController {
  var productList = <dynamic>[].obs;
  var isLoading = false.obs;
  var product = Rxn<Map<String, dynamic>>();
  var filteredProductList = <dynamic>[].obs;
  var searchQuery = ''.obs;
  var selectedSortOption = ''.obs;
  var selectedCategories = <String>[].obs;
  var minPrice = ''.obs;
  var maxPrice = ''.obs;
  var maxRating = ''.obs;
  var isPriceFilterEnabled = false.obs;
  var isRatingFilterEnabled = false.obs;
  Timer? _debounce;
  final CartController cartController = Get.put(CartController());
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getAllProducts();
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> getAllProducts() async {
    try {
      isLoading.value = true;
      var response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        productList.value = json.decode(response.body);
      } else {
        Template.showSnackbar(
            title: "Error", message: "Failed to load products");
      }
    } catch (e) {
      Template.showSnackbar(title: "Error", message: "Something went wrong");
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
    if (sortBy == "None") {
      resetSort();
      return;
    }

    selectedSortOption.value = sortBy;

    List<dynamic> sortingList = List.from(
        filteredProductList.isNotEmpty ? filteredProductList : productList);

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

    filteredProductList.value = sortingList;
    filteredProductList.refresh();
  }

  void resetSort() {
    selectedSortOption.value = "";
    filteredProductList.value = List.from(productList);
    filteredProductList.refresh();
  }

  Future<void> applyFilters() async {
    double? minPriceValue =
        isPriceFilterEnabled.value && minPrice.value.isNotEmpty
            ? double.tryParse(minPrice.value)
            : null;
    double? maxPriceValue =
        isPriceFilterEnabled.value && maxPrice.value.isNotEmpty
            ? double.tryParse(maxPrice.value)
            : null;

    // double minRatingValue = isRatingFilterEnabled.value ? ratingRange.start : 1;
    // double maxRatingValue = isRatingFilterEnabled.value ? ratingRange.end : 5;

    filteredProductList.value = await productList.where((product) {
      bool matchesSearch = searchQuery.value.isEmpty ||
          product["title"]
              .toString()
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      bool matchesCategory = selectedCategories.isEmpty ||
          selectedCategories
              .map((e) => e.toLowerCase().trim())
              .contains(product["category"].toString().toLowerCase().trim());

      bool matchesPrice = true;
      if (isPriceFilterEnabled.value &&
          minPriceValue != null &&
          maxPriceValue != null) {
        matchesPrice = product["price"] >= minPriceValue &&
            product["price"] <= maxPriceValue;
      }

      bool matchesRating = !isRatingFilterEnabled.value ||
          (product["rating"]["rate"] is num &&
              (product["rating"]["rate"] as num).toDouble() <=
                  (double.tryParse(maxRating.value) ?? 5.0));

      return matchesSearch && matchesCategory && matchesPrice && matchesRating;
    }).toList();

    filteredProductList.refresh();

    if (selectedSortOption.isNotEmpty) {
      sortProducts(selectedSortOption.value);
    }
  }

  RangeValues ratingRange = RangeValues(1, 5);
  void resetFilters() {
    selectedCategories.clear();
    minPrice.value = '1';
    maxPrice.value = '1000';

    ratingRange = RangeValues(1, 5);

    searchQuery.value = "";

    filteredProductList.assignAll(productList);
    filteredProductList.refresh();
  }

  List<dynamic> get filteredProducts {
    if (filteredProductList.isNotEmpty) {
      return filteredProductList;
    }
    return productList;
  }

  // void clearSearch() {
  //   searchController.clear();
  //   searchQuery.value = '';
  //   filteredProductList.value = List.from(productList);
  // }

  // void searchProducts(String query) {
  //   searchQuery.value = query;

  //   if (query.isEmpty) {
  //     filteredProductList.value = List.from(productList);
  //   } else {
  //     filteredProductList.value = productList
  //         .where((product) => product['title']
  //             .toString()
  //             .toLowerCase()
  //             .contains(query.toLowerCase()))
  //         .toList();
  //   }
  // }

  void searchProducts(String query) {
    searchQuery.value = query;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        filteredProductList.value = List.from(productList);
      } else {
        filteredProductList.value = productList
            .where((product) => product['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredProductList.value = List.from(productList);
  }
}
