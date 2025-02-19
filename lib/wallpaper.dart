import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/fullscreen.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  List images = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  //fetch data from api
  fetchApi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              'tmoKwO37HS3qoZKObCJIDKWiI4AP2USii3Wl59YgC0eepgIVRrjHsqHm'
        }).then((value) {
      //print(value.body);
      Map result = jsonDecode(value.body);
      //print(result);
      setState(() {
        images = result['photos'];
      });
      print(images);
    });
  }

  //load more
  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          'tmoKwO37HS3qoZKObCJIDKWiI4AP2USii3Wl59YgC0eepgIVRrjHsqHm'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: Container(
            child: GridView.builder(
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreen(
                                      imageUrl: images[index]['src']['large2x'],
                                    )));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Image.network(
                          images[index]['src']['small'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
          )),
          Material(
            child: InkWell(
              onTap: () {
                loadMore();
              },
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'load more',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
