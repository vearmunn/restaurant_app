import 'package:flutter/material.dart';

import '../model/detail_restaurant_model.dart';

class MenuWidget extends StatelessWidget {
  final String title;
  final List<Category> menu;
  const MenuWidget({
    Key? key,
    required this.title,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: menu.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Text(
                  menu[index].name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ));
          },
        ),
      ],
    );
  }
}
