class RestaurantViewModel {
  int _id;
  String _title;
  int _item;

  RestaurantViewModel(
      {int id,
        String title,
        int item}) {
    this._id = id;
    this._title = title;
    this._item = item;
  }

  int get id => _id;
  String get title => _title;
  int get item => _item;

  RestaurantViewModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _item = json['item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['resName'] = this._title;
    data['item'] = this._item;
    return data;
  }
}
