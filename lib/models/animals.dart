class Animal {
  String? name;
  String? imgSrc;
  String? soundSrc;
  String? soundEn;

  Animal({this.name, this.imgSrc, this.soundSrc});

  Animal.fromJson(dynamic json) {
    name = json['name'];
    imgSrc = json['img_src'];
    soundSrc = json['sound_src'];
    soundEn = json["sound_en"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['img_src'] = imgSrc;
    map['sound_src'] = soundSrc;
    map['sound_en'] = soundEn;
    return map;
  }
}
