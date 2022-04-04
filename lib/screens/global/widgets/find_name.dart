import 'package:flutter/material.dart';

class FindName {
  static FutureBuilder<String> name(Future<String> future) {
    return FutureBuilder<String>(
        future: future,
        builder: (_, snap) => snap.hasData ? Text(snap.data!) : const Text(""));
  }
}
