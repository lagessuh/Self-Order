import 'package:flutter/material.dart';

class CarrinhoVazioCard extends StatelessWidget {
  const CarrinhoVazioCard(
      {super.key, required this.title, required this.iconData});

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            size: 80.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
