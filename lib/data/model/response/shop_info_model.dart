class ShopModel {
  int id;
  String name;
  String address;
  String contact;
  String image;
  String createdAt;
  String updatedAt;
  String banner;
  double ratting;
  int rattingCount;

  ShopModel(
      {this.id,
        this.name,
        this.address,
        this.contact,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.banner,
        this.ratting,
        this.rattingCount
      });

  ShopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    contact = json['contact'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    banner = json['banner'];
    ratting = json['rating'].toDouble();
    rattingCount = json['rating_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    // data['seller_id'] = this.sellerId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['banner'] = this.banner;
    data['rating'] = this.ratting;
    data['rating_count'] = this.rattingCount;
    return data;
  }
}
