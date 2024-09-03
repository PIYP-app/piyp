import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselBottomBar extends StatelessWidget {
  const CarouselBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(100, 246, 246, 246),
            border: Border(
                top: BorderSide(
              color: Colors.grey,
              width: 1,
            ))),
        height: 73,
        padding: const EdgeInsets.all(24.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(child: Icon(color: Colors.blue, CupertinoIcons.share)),
          ],
        ));
  }
}
