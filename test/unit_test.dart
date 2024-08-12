import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/model/detail_restaurant_model.dart';

void main() async {
  test('Tes nyalakan notifikasi', () async {
    bool notificationEnabled = false;

    notificationEnabled = !notificationEnabled;

    expect(notificationEnabled, true);
  });

  test('Tes parse data detail restoran dan ambil namanya', () async {
    final file = File('assets/detail_restoran.json').readAsStringSync();
    final DetailRestaurantModel detailRestaurant =
        DetailRestaurantModel.fromJson(jsonDecode(file));

    expect(detailRestaurant.restaurant!.name, 'Melting Pot');
  });
  
}
