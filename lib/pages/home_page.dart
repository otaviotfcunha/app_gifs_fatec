import 'dart:convert';
import 'package:app_gifs_fatec/pages/gif_page.dart';
import 'package:app_gifs_fatec/shared/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;
  late Uri _url;

  Future<Map> _() async {
    http.Response resposta;

    if (_search.isEmpty) {
      _url = Uri.https("api.giphy.com", "/v1/gifs/trending",
          {"api_key": dotenv.get("APPRESTAPI_KEY")});
    } else {
      _url = Uri.https("api.giphy.com", "v1/gifs/search", {
        "api_key": dotenv.get("APPRESTAPI_KEY"),
        "q": _search,
        "limit": "25",
        "offset": _offset.toString(),
        "rating": "g",
        "lang": "en"
      });
    }
    resposta = await http.get(_url);
    return json.decode(resposta.body);
  }

  @override
  void initState() {
    super.initState();
    _().then((gif) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Image.network(AppImages.logo_giphy),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.white),
                hintText: "Digite um texto para buscar gifs...",
                fillColor: Colors.black,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _(),
                builder: (context, gif) {
                  switch (gif.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (gif.hasError) {
                        return Container();
                      } else {
                        return _criaGifWidget(context, gif);
                      }
                  }
                }),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _criaGifWidget(BuildContext context, AsyncSnapshot gif) {
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _getCount(gif.data["data"]),
        itemBuilder: (context, index) {
          if (_search.isEmpty || index < gif.data["data"].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: gif.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(gif.data["data"][index])));
              },
              onLongPress: () {},
            );
          } else {
            return GestureDetector(
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            );
          }
        });
  }
}
