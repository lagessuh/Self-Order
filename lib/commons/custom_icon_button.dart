import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.iconData,
      required this.color,
      required this.onTap,
      required this.size});
  final IconData iconData;
  final Color color;
  final double? size;
  //utilizado para ser recebido como parâmetro e
  //referenciado pela chamada onTap: do InkWell
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        //este componente (InkWell) somente será animado (apresentação de um movimento)
        //se ele estiver dentro de um Material (é como se espalhássemos uma tinta no widget)
        //poderíamos utilizar o GestureDetector
        //(precisamos que o InkWell fique subordinado ao Material para permitir o uso das cores pintadas)
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconData,
              color: onTap != null ? color : Colors.grey[400],
              size: size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}
