import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var maskCPFFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
var maskPhoneFormatter = MaskTextInputFormatter(
    mask: '(##) #########', filter: {"#": RegExp(r'[0-9]')});
var maskCEPFormatter = MaskTextInputFormatter(
    mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
var maskDateFormatter = MaskTextInputFormatter(
    mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});