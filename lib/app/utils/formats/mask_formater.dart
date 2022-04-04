import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:money_input_formatter/money_input_formatter.dart';

var telMaskFormatter = MaskTextInputFormatter(
  mask: '## ## ## ##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);
var prixMaskFormatter = MaskTextInputFormatter(
  mask: '#######################',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);
var imeiMaskFormatter = MaskTextInputFormatter(
  mask: '####',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

var nameMaskFormatter = MaskTextInputFormatter(
  mask: "#############################################",
  filter: {"#": RegExp(r'[a-z A-Z á-ú Á-Ú]')},
  type: MaskAutoCompletionType.lazy,
);
var nameAndNumMaskFormatter = MaskTextInputFormatter(
  mask: "#############################################",
  filter: {"#": RegExp(r'[a-z A-Z á-ú Á-Ú 0-9]')},
  type: MaskAutoCompletionType.lazy,
);

List<TextInputFormatter> prixInputFormatters() {
  return [
    MoneyInputFormatter(),
    FilteringTextInputFormatter.allow(RegExp(r'[ 0-9]')),
    FilteringTextInputFormatter.deny(RegExp(r'[;,]'))
  ];
}
