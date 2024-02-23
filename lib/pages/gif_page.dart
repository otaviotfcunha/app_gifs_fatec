import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _gifData["title"],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Center(
              child: Image.network(_gifData["images"]["fixed_height"]["url"])),
          TextButton(
              onPressed: () {},
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 32, 69, 204))),
              child: const Text(
                "Compartilhar",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )),
        ],
      ),
    );
  }
}
