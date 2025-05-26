import 'package:flutter/material.dart';

PreferredSizeWidget arrowBackAppBar(
  BuildContext context, {
  String title = ' ',
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.all(1),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 2),
          ),
          padding: const EdgeInsets.all(2),
          child: const Icon(Icons.arrow_back, size: 30, color: Colors.grey),
        ),
      ),
    ),
    title: Text(
      title,
      style: TextStyle(fontFamily: 'Oswald', fontSize: 28, color: Colors.black),
    ),
    centerTitle: true,
  );
}
