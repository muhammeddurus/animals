import 'package:animal_app/models/animals.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';

class Detay extends StatefulWidget {
  final Animal? tumHayvanlar;
  Detay({this.tumHayvanlar});

  @override
  _DetayState createState() => _DetayState();
}

class _DetayState extends State<Detay> {
  late AudioPlayer player;
  Color appbarRengi = Colors.pink;
  late PaletteGenerator _generator;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    appbarRenginiBul();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          child: Icon(Icons.home),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Hero(
            tag: "${widget.tumHayvanlar!.imgSrc}",
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.tumHayvanlar!.imgSrc.toString()),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: 15,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 4,
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: 120,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              image: DecorationImage(
                                  image: AssetImage(
                                      widget.tumHayvanlar!.imgSrc.toString()),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tumHayvanlar!.name.toString(),
                              style: TextStyle(
                                  fontFamily: 'MyFont',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                fontFamily: 'MyFont',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 10, bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 30),
                                child: FloatingActionButton(
                                  heroTag: "b",
                                  onPressed: () async {
                                    await player.setAsset(widget
                                        .tumHayvanlar!.soundSrc
                                        .toString());
                                    player.play();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("SES"),
                                      Center(
                                          child: Icon(
                                        Icons.volume_up,
                                      )),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 30),
                                child: FloatingActionButton(
                                  heroTag: "c",
                                  onPressed: () async {
                                    player.setAsset(widget.tumHayvanlar!.soundEn
                                        .toString());
                                    player.play();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("EN"),
                                      Center(
                                          child: Icon(
                                        Icons.language,
                                      )),
                                    ],
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void appbarRenginiBul() async {
    _generator = await PaletteGenerator.fromImageProvider(
        AssetImage(widget.tumHayvanlar!.imgSrc.toString()));
    appbarRengi = _generator.dominantColor!.color;
    setState(() {});
  }
}
