class ProductModel {
  int _totalSize;
  int _limit;
  int _offset;
  List<Product> _products;

  ProductModel(
      {int totalSize, int limit, int offset, List<Product> products}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._products = products;
  }

  int get totalSize => _totalSize;
  int get limit => _limit;
  int get offset => _offset;
  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int id;
  String addedBy;
  int userId;
  String name;
  int brandId;
  List<CategoryIds> categoryIds;
  String unit;
  List<String> images;
  String thumbnail;
  List<ProductColors> colors;
  List<int> attributes;
  List<ChoiceOptions> choiceOptions;
  List<Variation> variation;
  double unitPrice;
  double purchasePrice;
  double tax;
  int minQty;
  String taxType;
  double discount;
  String discountType;
  int currentStock;
  String details;
  String createdAt;
  String updatedAt;
  List<Rating> rating;
  String metaTitle;
  String metaDescription;
  String metaImage;
  double shippingCost;
  int multiplyWithQuantity;

  Product(
      {int id,
        String addedBy,
        int userId,
        String name,
        int brandId,
        List<CategoryIds> categoryIds,
        String unit,
        int minQty,
        List<String> images,
        String thumbnail,
        List<ProductColors> colors,
        String variantProduct,
        List<int> attributes,
        List<ChoiceOptions> choiceOptions,
        List<Variation> variation,
        double unitPrice,
        double purchasePrice,
        double tax,
        String taxType,
        double discount,
        String discountType,
        int currentStock,
        String details,
        String attachment,
        String createdAt,
        String updatedAt,
        int featuredStatus,
        List<Rating> rating,
        String metaTitle,
        String metaDescription,
        String metaImage,
        double shippingCost,
        int multiplyWithQuantity,
      }) {
    this.id = id;
    this.addedBy = addedBy;
    this.userId = userId;
    this.name = name;
    this.brandId = brandId;
    this.categoryIds = categoryIds;
    this.unit = unit;
    this.minQty = minQty;
    this.images = images;
    this.thumbnail = thumbnail;
    this.colors = colors;
    this.attributes = attributes;
    this.choiceOptions = choiceOptions;
    this.variation = variation;
    this.unitPrice = unitPrice;
    this.purchasePrice = purchasePrice;
    this.tax = tax;
    this.taxType = taxType;
    this.discount = discount;
    this.discountType = discountType;
    this.currentStock = currentStock;
    this.details = details;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.rating = rating;
    this.metaTitle = metaTitle;
    this.metaDescription = metaDescription;
    this.metaImage = metaImage;
    this.shippingCost = shippingCost;
    this.multiplyWithQuantity = multiplyWithQuantity;
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    userId = json['user_id'];
    name = json['name'];
    brandId = json['brand_id'];
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds.add(new CategoryIds.fromJson(v));
      });
    }
    unit = json['unit'];
    minQty = json['min_qty'];
    if(json['images'] != null){
      images = json['images'] != null ? json['images'].cast<String>() : [];
    }

    thumbnail = json['thumbnail'];
    if (json['colors'] != null) {
      colors = [];
      json['colors'].forEach((v) {
        colors.add(new ProductColors.fromJson(v));
      });
    }
    if(json['attributes'] != null) {
      attributes = [];
      for(int index=0; index<json['attributes'].length; index++) {
        attributes.add(int.parse(json['attributes'][index].toString()));
      }
    }
    if (json['choice_options'] != null) {
      choiceOptions = [];
      json['choice_options'].forEach((v) {
        choiceOptions.add(new ChoiceOptions.fromJson(v));
      });
    }
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation.add(new Variation.fromJson(v));
      });
    }
    unitPrice = json['unit_price'].toDouble();
    purchasePrice = json['purchase_price'].toDouble();
    tax = json['tax'].toDouble();
    taxType = json['tax_type'];
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    currentStock = json['current_stock'];
    details = json['details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['rating'] != null) {
      rating = [];
      json['rating'].forEach((v) {
        rating.add(new Rating.fromJson(v));
      });
    }
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    metaImage = json['meta_image'];
    if(json['shipping_cost']!=null){
      shippingCost = json['shipping_cost'].toDouble();
    }
    if(json['multiply_qty']!=null){
      multiplyWithQuantity = json['multiply_qty'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['added_by'] = this.addedBy;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['brand_id'] = this.brandId;
    if (this.categoryIds != null) {
      data['category_ids'] = this.categoryIds.map((v) => v.toJson()).toList();
    }
    data['unit'] = this.unit;
    data['min_qty'] = this.minQty;
    data['images'] = this.images;
    data['thumbnail'] = this.thumbnail;
    if (this.colors != null) {
      data['colors'] = this.colors.map((v) => v.toJson()).toList();
    }
    data['attributes'] = this.attributes;
    if (this.choiceOptions != null) {
      data['choice_options'] =
          this.choiceOptions.map((v) => v.toJson()).toList();
    }
    if (this.variation != null) {
      data['variation'] = this.variation.map((v) => v.toJson()).toList();
    }
    data['unit_price'] = this.unitPrice;
    data['purchase_price'] = this.purchasePrice;
    data['tax'] = this.tax;
    data['tax_type'] = this.taxType;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['current_stock'] = this.currentStock;
    data['details'] = this.details;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.rating != null) {
      data['rating'] = this.rating.map((v) => v.toJson()).toList();
    }
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['meta_image'] = this.metaImage;
    data['shipping_cost'] = this.shippingCost;
    data['multiply_qty'] = this.multiplyWithQuantity;
    return data;
  }
}

class CategoryIds {
  String id;
  int position;

  CategoryIds({String id, int position}) {
    this.id = id;
    this.position = position;
  }

  // String get id => _id;
  // int get position => _position;
  //

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    return data;
  }
}

class ProductColors {
  String _name;
  String _code;

  ProductColors({String name, String code}) {
    this._name = name;
    this._code = code;
  }

  String get name => _name;
  String get code => _code;

  ProductColors.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['code'] = this._code;
    return data;
  }
}

class ChoiceOptions {
  String _name;
  String _title;
  List<String> _options;

  ChoiceOptions({String name, String title, List<String> options}) {
    this._name = name;
    this._title = title;
    this._options = options;
  }

  String get name => _name;
  String get title => _title;
  List<String> get options => _options;

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['title'] = this._title;
    data['options'] = this._options;
    return data;
  }
}

class Variation {
  String _type;
  double _price;
  String _sku;
  int _qty;

  Variation({String type, double price, String sku, int qty}) {
    this._type = type;
    this._price = price;
    this._sku = sku;
    this._qty = qty;
  }

  String get type => _type;
  double get price => _price;
  String get sku => _sku;
  int get qty => _qty;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _price = json['price'].toDouble();
    _sku = json['sku'];
    _qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['price'] = this._price;
    data['sku'] = this._sku;
    data['qty'] = this._qty;
    return data;
  }
}

class Rating {
  String _average;
  int _productId;

  Rating({String average, int productId}) {
    this._average = average;
    this._productId = productId;
  }

  String get average => _average;
  int get productId => _productId;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'].toString();
    _productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this._average;
    data['product_id'] = this._productId;
    return data;
  }
}


