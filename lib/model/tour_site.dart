class TourSite {
  var id;
  String? title;
  String? tel;
  String? zipcode;
  String? address;
  var mapx;
  var mapy;
  String? imagePath;

  TourSite({this.id, this.title, this.tel, this.zipcode, this.address, this.mapx, this.mapy, this.imagePath});

  TourSite.fromJson(Map map):
    id = map['contentid'],
    title = map['title'],
    tel = map['tel'],
    zipcode = map['zipcode'],
    address = map['addr1'],
    mapx = map['mapx'],
    mapy = map['mapy'],
    imagePath = map['firstimage'];

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