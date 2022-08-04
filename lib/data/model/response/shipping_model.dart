class ShippingModel {
  int id;
  String title;
  String duration;
  double cost;

  ShippingModel({this.id, this.title, this.duration, this.cost});

  ShippingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    cost = json['cost'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['duration'] = this.duration;
    data['cost'] = this.cost;
    return data;
  }
}
