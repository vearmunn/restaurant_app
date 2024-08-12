import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/screens/restaurant_detail_page.dart';

import '../configs/statics.dart';
import '../controllers/restaurant_controller.dart';
import '../widgets/error_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<RestaurantController>();
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => controller.isSearchError.value
              ? CustomErrorWidget(
                  onTap: () {
                    Get.back();
                    controller.hasSearchedRestaurant.value = false;
                  },
                  buttonText: 'Kembali',
                  text: 'Tidak ada koneksi internet !')
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                  controller.hasSearchedRestaurant.value =
                                      false;
                                },
                                icon: const Icon(Icons.arrow_back)),
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                              width: MediaQuery.of(context).size.width - 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(15)),
                              child: TextField(
                                key:const Key('searchText'),
                                onSubmitted: (value) async {
                                  await controller.searchRestaurant(value);
                                },
                                textInputAction: TextInputAction.search,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.search),
                                    hintText: 'Cari restoran...'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => controller.isLoading.value
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.3),
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              )
                            : controller.hasSearchedRestaurant.value &&
                                    controller.searchRestaurantData.value
                                            .founded ==
                                        0
                                ? const Center(
                                    child: Text(
                                      'Restoran tidak ditemukan !',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.searchRestaurantData
                                        .value.restaurants!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var data = controller.searchRestaurantData
                                          .value.restaurants![index];
                                      return Card(
                                        elevation: 3,
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        child: ListTile(
                                          onTap: () {
                                            controller
                                                .fetchDetailRestaurant(data.id);
                                            Get.to(() =>
                                                const RestaurantDetailPage());
                                          },
                                          leading: Image.network(
                                              '$imageURL/medium/${data.pictureId}'),
                                          title: Text(data.name),
                                          subtitle: Text(data.city),
                                          trailing: Text(
                                            data.rating.toString(),
                                            style: const TextStyle(
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
