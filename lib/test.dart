import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
  final ValueNotifier<int> valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.minimize),
              ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (context, value, child) {
                  return Text(value.toString());
                },
              ),
              Icon(Icons.add)
            ],
          )
        ],
      ),
    );


  }

  void increase(){
    valueNotifier.value=valueNotifier.value++;
  }

  void descrease(){
    valueNotifier.value=valueNotifier.value--;
  }
}
