import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:restaurant_app/controllers/restaurant_controller.dart';

import '../configs/statics.dart';
import '../configs/styles.dart';
import '../widgets/error_widget.dart';
import '../widgets/menu_widget.dart';
import '../widgets/review_widget.dart';

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<RestaurantController>();
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.isDetailRestorantError.value
                  ? CustomErrorWidget(
                      onTap: () {
                        Get.back();
                      },
                      buttonText: 'Kembali',
                      text: 'Terjadi kesalahan!')
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                '$imageURL/medium/${controller.detailRestaurantData.value.restaurant!.pictureId}',
                                fit: BoxFit.cover,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                  controller.nameController.text = '';
                                  controller.reviewController.text = '';
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(16),
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white60),
                                  child: const Icon(Icons.arrow_back),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.detailRestaurantData.value
                                            .restaurant!.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Obx(
                                      () => GestureDetector(
                                        key:const Key('favoriteButton'),
                                        onTap: () {
                                          controller.setFavorite();
                                        },
                                        child: controller.restaurantId.value ==
                                                controller.detailRestaurantData
                                                    .value.restaurant!.id
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                Icons.favorite_border_outlined),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      size: 18,
                                      color: primaryColor,
                                    ),
                                    Expanded(
                                      child: Text(
                                        ' ${controller.detailRestaurantData.value.restaurant!.address}, ${controller.detailRestaurantData.value.restaurant!.city}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 14,
                                          ),
                                          Text(
                                            ' ${controller.detailRestaurantData.value.restaurant!.rating} ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  'Kategori',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.detailRestaurantData
                                      .value.restaurant!.categories.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(
                                      '- ${controller.detailRestaurantData.value.restaurant!.categories[index].name}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.orange),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  'Deskripsi',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  controller.detailRestaurantData.value
                                      .restaurant!.description,
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                MenuWidget(
                                  title: 'Makanan',
                                  menu: controller.detailRestaurantData.value
                                      .restaurant!.menus.foods,
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                MenuWidget(
                                  title: 'Minuman',
                                  menu: controller.detailRestaurantData.value
                                      .restaurant!.menus.drinks,
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Card(
                                  color: primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Review Anda',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Obx(
                                          () => TextField(
                                            controller:
                                                controller.nameController,
                                            decoration: InputDecoration(
                                                hintText: 'Nama...',
                                                errorText: controller
                                                        .validateName.value
                                                    ? 'Nama tidak boleh kosong!'
                                                    : null),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Obx(
                                          () => TextField(
                                            controller:
                                                controller.reviewController,
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Bagaimana pendapat Anda mengenai restoran ini?',
                                                errorText: controller
                                                        .validateReview.value
                                                    ? 'Minimal 6 karakter!'
                                                    : null),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.black),
                                              onPressed: () async {
                                                if (controller.nameController
                                                    .text.isEmpty) {
                                                  controller.validateName
                                                      .value = true;
                                                } else if (controller
                                                        .reviewController
                                                        .text
                                                        .length <
                                                    6) {
                                                  controller.validateReview
                                                      .value = true;
                                                } else {
                                                  controller.validateName
                                                      .value = false;
                                                  controller.validateReview
                                                      .value = false;
                                                  await controller.addReview(
                                                      controller
                                                          .detailRestaurantData
                                                          .value
                                                          .restaurant!
                                                          .id,
                                                      controller
                                                          .nameController.text,
                                                      controller
                                                          .reviewController
                                                          .text);
                                                }
                                              },
                                              child: const Text('Kirim Review',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                const Text(
                                  'Review Pelanggan',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Obx(
                                  () => controller.isLoading.value
                                      ? const SizedBox.shrink()
                                      : ListView.builder(
                                          reverse: true,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: controller
                                              .detailRestaurantData
                                              .value
                                              .restaurant!
                                              .customerReviews
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ReviewWidget(
                                              name: controller
                                                  .detailRestaurantData
                                                  .value
                                                  .restaurant!
                                                  .customerReviews[index]
                                                  .name,
                                              date: controller
                                                  .detailRestaurantData
                                                  .value
                                                  .restaurant!
                                                  .customerReviews[index]
                                                  .date,
                                              review: controller
                                                  .detailRestaurantData
                                                  .value
                                                  .restaurant!
                                                  .customerReviews[index]
                                                  .review,
                                            );
                                          },
                                        ),
                                ),
                              ],
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
