import 'dart:convert';

import 'package:get/get.dart';

import '../configs/statics.dart';
import '../model/detail_restaurant_model.dart';
import '../model/restaurants_model.dart';
import 'package:http/http.dart' as http;

import '../model/search_model.dart';
import '../model/tambah_review_model.dart';

class ApiService {
  static Future<DetailRestaurantModel> fetchDetailRestaurantTest(
      String id, http.Client client) async {
    String url = '.../detaol/$id';
    var response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Error");
    }
    var result = json.decode(response.body);

    return DetailRestaurantModel.fromJson(result);
  }

  Future<RestaurantsModel> fetchAllRestaurants() async {
    final response = await http
        .get(Uri.parse('$baseURL/list'))
        .timeout(const Duration(seconds: 15), onTimeout: () {
      Get.snackbar('Terjadi kesalahan!',
          'Server terlalu lama untuk memberi respon, silakan coba lagi!');
      return http.Response('Error', 408);
    });

    if (response.statusCode == 200) {
      return RestaurantsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat daftar restoran, silakan coba lagi!');
    }
  }

  Future<DetailRestaurantModel> fetchDetailRestaurant(String id) async {
    final response = await http
        .get(Uri.parse('$baseURL/detail/$id'))
        .timeout(const Duration(seconds: 15), onTimeout: () {
      Get.snackbar('Terjadi kesalahan!',
          'Server terlalu lama untuk memberi respon, silakan coba lagi!');
      return http.Response('Error', 408);
    });

    if (response.statusCode == 200) {
      return DetailRestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat detail restoran, silakan coba lagi!');
    }
  }

  Future<TambahReviewModel> addReview(
      String id, String name, String review) async {
    final response = await http.post(Uri.parse('$baseURL/review'),
        body: {"id": id, "name": name, "review": review});

    if (response.statusCode == 201) {
      return TambahReviewModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menambah review');
    }
  }

  Future<SearchModel> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse('$baseURL/search?q=$query'));

    if (response.statusCode == 200) {
      return SearchModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mencari restoran, silakan coba lagi!');
    }
  }
}
