import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:restaurant_app/configs/styles.dart';
import 'package:restaurant_app/controllers/restaurant_controller.dart';
import 'package:restaurant_app/screens/favorite_restaurants_page.dart';

import 'package:restaurant_app/screens/restaurant_detail_page.dart';
import 'package:restaurant_app/screens/search_page.dart';
import 'package:restaurant_app/screens/settings_page.dart';

import '../widgets/error_widget.dart';
import '../widgets/restaurant_card.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  void initState() {
    Get.put(RestaurantController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<RestaurantController>();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.isHomeError.value
                  ? CustomErrorWidget(
                      onTap: () {
                        controller.fetchAllRestaurants();
                      },
                      buttonText: 'Coba lagi',
                      text: 'Tidak ada koneksi internet!')
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ayo cari',
                              style: TextStyle(fontSize: 30),
                            ),
                            const Text(
                              'Restoran favoritmu!',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => const FavoriteRestaurants());
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(12),
                                      shape: const CircleBorder(),
                                      backgroundColor: primaryColor),
                                  child: const Icon(Icons.favorite_border),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // controller.searchRestaurant('kosong');
                                    Get.to(() => const SearchPage());
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(12),
                                      shape: const CircleBorder(),
                                      backgroundColor: primaryColor),
                                  child: const Icon(Icons.search),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Get.to(() => const SettingsPage());
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(12),
                                      shape: const CircleBorder(),
                                      backgroundColor: primaryColor),
                                  child: const Icon(Icons.settings_outlined),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            ListView.builder(
                              itemCount: controller
                                  .allRestaurantData.value.restaurants!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final restaurant = controller.allRestaurantData
                                    .value.restaurants![index];
                                return RestaurantCard(
                                  restaurant: restaurant,
                                  onTap: () {
                                    controller
                                        .fetchDetailRestaurant(restaurant.id);
                                    controller.getRestaurantById(restaurant.id);
                                    Get.to(() => const RestaurantDetailPage());
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
