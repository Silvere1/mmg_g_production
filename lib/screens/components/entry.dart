import 'package:flutter/material.dart';

class Entry extends StatelessWidget {
  const Entry({
    Key? key,
    required this.text,
    required this.editText,
  }) : super(key: key);
  final Widget text;
  final Widget editText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        text,
        const SizedBox(
          height: 8,
        ),
        editText,
      ],
    );
  }
}
