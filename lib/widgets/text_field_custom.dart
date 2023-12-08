import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trabalho_faculdade/util/colors.dart';

class TextFieldCustom extends StatelessWidget {
  TextFieldCustom(
      {Key? key,
      required this.text,
      required this.hint,
      this.isPassword = false,
      this.controller,
      this.getColorValidator,
      this.mask,
      this.readOnly = false,
      this.onTap,
      this.onTapAdd,
      this.onValidate,
      required this.inputType})
      : super(key: key);

  String text;
  String hint;
  bool isPassword;
  TextEditingController? controller;
  Color? getColorValidator;
  TextInputFormatter? mask;
  TextInputType inputType;
  bool readOnly;
  Function()? onTap;
  Function()? onTapAdd;
  final String? Function(String?)? onValidate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500),),
            Visibility(
              visible: onTapAdd != null,
              child: IconButton(
                  onPressed: onTapAdd,
                  icon: const Icon(Icons.add, color: Colors.black,)),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        TextFormField(
          validator: onValidate,
          onTap: onTap,
          readOnly: readOnly,
          inputFormatters: mask != null ? [mask!] : [],
          controller: controller,
          keyboardType: inputType,
          obscureText: isPassword,
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
              isDense: true,
              hintText: hint),
        ),
      ],
    );
  }
}
