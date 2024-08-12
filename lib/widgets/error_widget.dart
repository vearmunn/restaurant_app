import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String text;
  final void Function() onTap;
  
  final String buttonText;

  const CustomErrorWidget({
    Key? key,
    required this.text,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset(
                'assets/error_image.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Text('Error!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 12,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32)),
                child:  Text(buttonText)),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
