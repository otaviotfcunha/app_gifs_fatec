import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {
  final Map _meuGif;

  const GifPage(this._meuGif, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _meuGif["title"],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Center(
              child: Image.network(_meuGif["images"]["fixed_height"]["url"])),
          TextButton(
              onPressed: () {},
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 32, 69, 204))),
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
