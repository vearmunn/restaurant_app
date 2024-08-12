import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/configs/styles.dart';
import 'package:restaurant_app/controllers/restaurant_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<RestaurantController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Notifikasi Restoran'),
            subtitle: const Text(
                'Menampilkan restoran secara acak pada pukul 11.00'),
            trailing: Obx(
              () => Switch(
                  activeColor: primaryColor,
                  value: controller.enableNotification.value,
                  onChanged: (v) async {
                    controller.setNotification(v);
                    // controller.setNotification();
                  }),
            ),
          )
        ],
      ),
    );
  }
}
