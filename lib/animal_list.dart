import 'dart:convert';

import 'package:animal_app/animal_details.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'models/animals.dart';

class AnimalList extends StatefulWidget {
  @override
  _AnimalListState createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {
  List<Animal>? tumHayvanlar;

  BannerAd? _bannerAd;
  bool _bannerisLoaded = false;

  InterstitialAd? _interstitialAd;
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-2452889629536861/6000037889',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(
            () {
              isLoaded = true;
              this._interstitialAd = ad;
              print("Ad loaded");
            },
          );
        },
        onAdFailedToLoad: (error) {
          print("Interstitial Failed to Load");
        },
      ),
    );
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-2452889629536861/5780111264',
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _bannerisLoaded = true;
        });
        print("Banner Loaded.");
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
      request: AdRequest(),
    );
    _bannerAd!.load();
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text(
          "Hayvanlar Alemi",
          style: TextStyle(fontSize: 30, fontFamily: 'MyFont'),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Expanded(child: buildFutureBuilder()),
          ),
          _bannerisLoaded
              ? Container(
                  color: Colors.black,
                  height: 50,
                  child: AdWidget(
                    ad: _bannerAd!,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  FutureBuilder<List<dynamic>> buildFutureBuilder() {
    return FutureBuilder(
        future: veriKaynaginiOku(),
        builder: (context, sonuc) {
          //future un döndürdüğü SONUÇ u sonuca atıyoruz.
          if (sonuc.hasData) {
            tumHayvanlar = sonuc.data as List<Animal>?;
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (isLoaded) {
                      _interstitialAd!.show();
                    }
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Detay(
                        tumHayvanlar: tumHayvanlar![index],
                      );
                    }));
                  },
                  child: Hero(
                    tag: "${tumHayvanlar![index].imgSrc}",
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.pink[100 * ((index + 1) % 8)],
                                gradient: LinearGradient(
                                    colors: [Colors.yellow, Colors.transparent],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                image: DecorationImage(
                                  image: AssetImage(
                                      tumHayvanlar![index].imgSrc.toString()),
                                  fit: BoxFit.fill,
                                  alignment: Alignment.topCenter,
                                ),
                                border: Border.all(
                                    color: Colors.transparent,
                                    width: 5,
                                    style: BorderStyle.solid),
                                // borderRadius: new BorderRadius.all(new Radius.circular(5)),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.yellow,
                                    offset: new Offset(10.0, 5.0),
                                    blurRadius: 20.0,
                                  )
                                ],
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: tumHayvanlar?.length,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<List> veriKaynaginiOku() async {
    var gelenJson = await DefaultAssetBundle.of(context)
        .loadString('assets/data/animal.json');

    List<Animal> hayvanListesi = (json.decode(gelenJson) as List)
        .map((mapYapisi) => Animal.fromJson(mapYapisi))
        .toList();

    return hayvanListesi;
  }
}
