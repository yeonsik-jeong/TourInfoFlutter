class TourSiteInfo {
  var id;
  String? title;
  String? tel;
  String? zipcode;
  String? address;
  var mapx;
  var mapy;
  String? imagePath;

  TourSiteInfo({this.id, this.title, this.tel, this.zipcode, this.address, this.mapx, this.mapy, this.imagePath});

  TourSiteInfo.fromJson(Map map):
    id = map['id'],
    title = map['title'],
    tel = map['tel'],
    zipcode = map['zipcode'],
    address = map['address'],
    mapx = map['mapx'],
    mapy = map['mapy'],
    imagePath = map['imagePath'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tel': tel,
      'zipcode': zipcode,
      'address': address,
      'mapx': mapx,
      'mapy': mapy,
      'imagePath': imagePath,
    };
  }
}