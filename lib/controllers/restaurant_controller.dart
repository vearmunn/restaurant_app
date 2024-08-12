import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/configs/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../configs/notification_helper.dart';
import '../model/detail_restaurant_model.dart';
import '../model/restaurants_model.dart';
import '../model/search_model.dart';
import '../services/api_service.dart';

class RestaurantController extends GetxController {
  final apiService = ApiService();
  late SQLHelper sqlHelper;
  final NotificationHelper notificationHelper = NotificationHelper();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var allRestaurantData = RestaurantsModel().obs;
  var detailRestaurantData = DetailRestaurantModel().obs;
  var searchRestaurantData =
      SearchModel(error: false, founded: 0, restaurants: []).obs;
  var favoriteRestaurantData = [].obs;
  var restaurantId = ''.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  var validateName = false.obs;
  var validateReview = false.obs;

  var isLoading = false.obs;
  var isHomeError = false.obs;
  var isDetailRestorantError = false.obs;
  var isSearchError = false.obs;

  var enableNotification = false.obs;
  var hasSearchedRestaurant = false.obs;

  @override
  void onInit() async {
    sqlHelper = SQLHelper();

    await fetchAllRestaurants();
    getAllFavoriteRestaurants();
    getNotification();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  Future fetchAllRestaurants() async {
    try {
      isLoading.value = true;
      var response = await apiService.fetchAllRestaurants();
      allRestaurantData.value = response;
      isHomeError.value = false;
    } on SocketException catch (e) {
      allRestaurantData.value.message = e.toString();
      isHomeError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future fetchDetailRestaurant(String id) async {
    try {
      isLoading.value = true;
      var response = await apiService.fetchDetailRestaurant(id);
      isDetailRestorantError.value = false;
      detailRestaurantData.value = response;
    } on Exception catch (e) {
      detailRestaurantData.value.message = e.toString();
      isDetailRestorantError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future addReview(String id, String name, String review) async {
    try {
      isLoading.value = true;
      nameController.text = '';
      reviewController.text = '';
      isDetailRestorantError.value = false;
      var response = await apiService.addReview(id, name, review);
      detailRestaurantData.value.restaurant!.customerReviews =
          response.customerReviews;
      Get.showSnackbar(
        const GetSnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            message: 'Sukses menambahkan review!'),
      );
    } on Exception catch (e) {
      detailRestaurantData.value.message = e.toString();
      isDetailRestorantError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future searchRestaurant(String query) async {
    try {
      isLoading.value = true;
      var response = await apiService.searchRestaurant(query);
      searchRestaurantData.value = response;
      hasSearchedRestaurant.value = true;
      isSearchError.value = false;
    } on SocketException catch (_) {
      isSearchError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void getAllFavoriteRestaurants() async {
    favoriteRestaurantData.value = await sqlHelper.getFavoriteRestaurants();
  }

  Future addFavoriteRestaurant(String id, String pictureId, String name,
      String city, double rating) async {
    await sqlHelper.insertFavorite(id, pictureId, name, city, rating);
    getAllFavoriteRestaurants();
  }

  Future getRestaurantById(String id) async {
    try {
      isLoading.value = true;
      final res = await sqlHelper.getRestaurantById(id);
      restaurantId.value = res[0]['id'];
    } catch (_) {
      restaurantId.value = '';
    }
  }

  Future deleteFavoriteRestaurant(String id) async {
    await sqlHelper.deleteFavoriteRestaurant(id);
    getAllFavoriteRestaurants();
  }

  void setFavorite() {
    if (restaurantId.value == detailRestaurantData.value.restaurant!.id) {
      deleteFavoriteRestaurant(detailRestaurantData.value.restaurant!.id);
      restaurantId.value = '';
    } else {
      addFavoriteRestaurant(
          detailRestaurantData.value.restaurant!.id,
          detailRestaurantData.value.restaurant!.pictureId,
          detailRestaurantData.value.restaurant!.name,
          detailRestaurantData.value.restaurant!.city,
          detailRestaurantData.value.restaurant!.rating);
      restaurantId.value = detailRestaurantData.value.restaurant!.id;
    }
  }

  String notificationBody() {
    var randomIndex =
        Random().nextInt(allRestaurantData.value.restaurants!.length);
    var randomRestaurant = allRestaurantData.value.restaurants![randomIndex];
    return randomRestaurant.name;
  }

  void setNotification(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    enableNotification.value = v;
    prefs.setBool('notif', enableNotification.value);
    if (enableNotification.value) {
      await notificationHelper.scheduleNotification(
          flutterLocalNotificationsPlugin, notificationBody());
    }
  }

  void getNotification() async {
    final prefs = await SharedPreferences.getInstance();
    enableNotification.value = prefs.getBool('notif') ?? false;
    if (enableNotification.value) {
      await notificationHelper.scheduleNotification(
          flutterLocalNotificationsPlugin, notificationBody());
    }
  }
}
