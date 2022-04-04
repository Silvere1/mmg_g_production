import 'package:flutter/material.dart';

ButtonStyle buildValidateBtnStyle() {
  return ElevatedButton.styleFrom(
    minimumSize: const Size(0, 0),
    padding: const EdgeInsets.all(10),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
    //primary: Colors.white,
  );
}

ButtonStyle buildCancelBtnStyle() {
  return ElevatedButton.styleFrom(
    minimumSize: const Size(0, 0),
    padding: const EdgeInsets.all(10),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
    primary: Colors.white,
  );
}
