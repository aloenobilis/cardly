import 'package:flutter/material.dart';

Widget loader() {
  return Container(
    color: Colors.grey[900],
    child: const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    ),
  );
}
