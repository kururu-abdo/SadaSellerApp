class RestaurantModel {
  int _id;
  String _resName;
  String _image;
  String _location;
  String _rating;
  String _distance;
  String _time;
  String _availableTimeStarts;
  String _availableTimeEnds;
  String _discount;
  String _description;
  double _price;

  RestaurantModel(
      {int id,
        String resName,
        String image,
        String location,
        String rating,
        String distance,
        String time,
        String availableTimeStarts,
        String availableTimeEnds,
        String discount,
        String description,
      double price}) {
    this._id = id;
    this._resName = resName;
    this._image = image;
    this._location = location;
    this._rating = rating;
    this._distance = distance;
    this._time = time;
    this._availableTimeStarts = availableTimeStarts;
    this._availableTimeEnds = availableTimeEnds;
    this._discount = discount;
    this._description = description;
    this._price = price;
  }

  int get id => _id;
  String get resName => _resName;
  String get image => _image;
  String get location => _location;
  String get rating => _rating;
  String get distance => _distance;
  String get time => _time;
  String get availableTimeStarts => _availableTimeStarts;
  String get availableTimeEnds => _availableTimeEnds;
  String get discount => _discount;
  String get description => _description;
  double get price => _price;

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _resName = json['resName'];
    _image = json['image'];
    _location = json['location'];
    _rating = json['rating'];
    _distance = json['distance'];
    _time = json['time'];
    _availableTimeStarts = json['availableTimeStarts'];
    _availableTimeEnds = json['availableTimeEnds'];
    _discount = json['discount'];
    _description = json['description'];
    _price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['resName'] = this._resName;
    data['image'] = this._image;
    data['location'] = this._location;
    data['rating'] = this._rating;
    data['distance'] = this._distance;
    data['time'] = this._time;
    data['availableTimeStarts'] = this._availableTimeStarts;
    data['availableTimeEnds'] = this._availableTimeEnds;
    data['discount'] = this._discount;
    data['description'] = this._description;
    data['price'] = this._price;
    return data;
  }
}
