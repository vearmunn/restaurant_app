import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/statics.dart';
import '../controllers/restaurant_controller.dart';
import 'restaurant_detail_page.dart';

class FavoriteRestaurants extends StatelessWidget {
  const FavoriteRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<RestaurantController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite Restaurants'),
      ),
      body: Obx(
        () => controller.favoriteRestaurantData.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada restoran favorit!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.favoriteRestaurantData.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = controller.favoriteRestaurantData[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                        onTap: () {
                          controller.fetchDetailRestaurant(data['id']);
                          Get.to(() => const RestaurantDetailPage());
                        },
                        isThreeLine: true,
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                                '$imageURL/medium/${data['pictureId']}')),
                        title: Text(data['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['city']),
                            Text(
                              data['rating'].toString(),
                              style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              controller.deleteFavoriteRestaurant(data['id']);
                            },
                            icon: const Icon(Icons.delete))),
                  );
                },
              ),
      ),
    );
  }
}
