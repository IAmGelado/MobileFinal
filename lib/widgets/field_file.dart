import 'package:flutter/material.dart';

class FieldFile extends StatelessWidget {
  FieldFile({Key? key, required this.title, required this.text, required this.color, required this.onTap}) : super(key: key);

  String title;
  String text;
  Color color;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500),
              ),
              IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.upload)),
            ],
          ),
        ),
        Text(
            text ?? "-"
        ),
      ],
    );
  }
}
