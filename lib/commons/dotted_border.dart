import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

Widget dottedBorder({Color? color, VoidCallback? readImage}) {
  return DottedBorder(
      dashPattern: const [5],
      color: color!,
      child: Column(
        children: [
          IconButton(
            iconSize: 80,
            icon: const Icon(Icons.image_search_rounded),
            onPressed: readImage,
          ),
          Text(
            "Foto",
            style: TextStyle(color: color),
          )
        ],
      ));
}
