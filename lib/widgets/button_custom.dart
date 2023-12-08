import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/util/colors.dart';

class ButtonCustom extends StatelessWidget {
  ButtonCustom({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  String title;
  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style:  ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor
        ),
        onPressed: onPressed,
        child: SizedBox(
            height: 40,
            child: Center(
              child: Text(title,
                  style:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            )),
      ),
    );
  }
}
