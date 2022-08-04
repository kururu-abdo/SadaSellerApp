
class MessageModel {
  int _id;
  int _userId;
  int _sellerId;
  String _message;
  int _sentByCustomer;
  int _sentBySeller;
  int _seenByCustomer;
  int _seenBySeller;
  int _status;
  String _createdAt;
  String _updatedAt;
  int _shopId;
  SellerInfo _sellerInfo;
  Customer _customer;
  Shop _shop;

  MessageModel(
      {int id,
        int userId,
        int sellerId,
        String message,
        int sentByCustomer,
        int sentBySeller,
        int seenByCustomer,
        int seenBySeller,
        int status,
        String createdAt,
        String updatedAt,
        int shopId,
        SellerInfo sellerInfo,
        Customer customer,
        Shop shop}) {
    this._id = id;
    this._userId = userId;
    this._sellerId = sellerId;
    this._message = message;
    this._sentByCustomer = sentByCustomer;
    this._sentBySeller = sentBySeller;
    this._seenByCustomer = seenByCustomer;
    this._seenBySeller = seenBySeller;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._shopId = shopId;
    this._sellerInfo = sellerInfo;
    this._customer = customer;
    this._shop = shop;
  }

  int get id => _id;
  int get userId => _userId;
  int get sellerId => _sellerId;
  String get message => _message;
  int get sentByCustomer => _sentByCustomer;
  int get sentBySeller => _sentBySeller;
  int get seenByCustomer => _seenByCustomer;
  int get seenBySeller => _seenBySeller;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get shopId => _shopId;
  SellerInfo get sellerInfo => _sellerInfo;
  Customer get customer => _customer;
  Shop get shop => _shop;

  MessageModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _sellerId = json['seller_id'];
    _message = json['message'];
    _sentByCustomer = json['sent_by_customer'];
    _sentBySeller = json['sent_by_seller'];
    _seenByCustomer = json['seen_by_customer'];
    _seenBySeller = json['seen_by_seller'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _shopId = json['shop_id'];
    _sellerInfo = json['seller_info'] != null
        ? new SellerInfo.fromJson(json['seller_info'])
        : null;
    _customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    _shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['seller_id'] = this._sellerId;
    data['message'] = this._message;
    data['sent_by_customer'] = this._sentByCustomer;
    data['sent_by_seller'] = this._sentBySeller;
    data['seen_by_customer'] = this._seenByCustomer;
    data['seen_by_seller'] = this._seenBySeller;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['shop_id'] = this._shopId;
    if (this._sellerInfo != null) {
      data['seller_info'] = this._sellerInfo.toJson();
    }
    if (this._customer != null) {
      data['customer'] = this._customer.toJson();
    }
    if (this._shop != null) {
      data['shop'] = this._shop.toJson();
    }
    return data;
  }
}

class SellerInfo {
  int _id;
  String _fName;
  String _lName;
  String _phone;
  String _image;
  String _email;
  String _password;
  String _status;
  String _rememberToken;
  String _createdAt;
  String _updatedAt;
  String _bankName;
  String _branch;
  String _accountNo;
  String _holderName;
  String _authToken;

  SellerInfo(
      {int id,
        String fName,
        String lName,
        String phone,
        String image,
        String email,
        String password,
        String status,
        String rememberToken,
        String createdAt,
        String updatedAt,
        String bankName,
        String branch,
        String accountNo,
        String holderName,
        String authToken}) {
    this._id = id;
    this._fName = fName;
    this._lName = lName;
    this._phone = phone;
    this._image = image;
    this._email = email;
    this._password = password;
    this._status = status;
    this._rememberToken = rememberToken;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._bankName = bankName;
    this._branch = branch;
    this._accountNo = accountNo;
    this._holderName = holderName;
    this._authToken = authToken;
  }

  int get id => _id;
  String get fName => _fName;
  String get lName => _lName;
  String get phone => _phone;
  String get image => _image;
  String get email => _email;
  String get password => _password;
  String get status => _status;
  String get rememberToken => _rememberToken;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get bankName => _bankName;
  String get branch => _branch;
  String get accountNo => _accountNo;
  String get holderName => _holderName;
  String get authToken => _authToken;

  SellerInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _image = json['image'];
    _email = json['email'];
    _password = json['password'];
    _status = json['status'];
    _rememberToken = json['remember_token'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _bankName = json['bank_name'];
    _branch = json['branch'];
    _accountNo = json['account_no'];
    _holderName = json['holder_name'];
    _authToken = json['auth_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['image'] = this._image;
    data['email'] = this._email;
    data['password'] = this._password;
    data['status'] = this._status;
    data['remember_token'] = this._rememberToken;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['bank_name'] = this._bankName;
    data['branch'] = this._branch;
    data['account_no'] = this._accountNo;
    data['holder_name'] = this._holderName;
    data['auth_token'] = this._authToken;
    return data;
  }
}

class Customer {
  int _id;
  String _name;
  String _fName;
  String _lName;
  String _phone;
  String _image;
  String _email;
  String _emailVerifiedAt;
  String _createdAt;
  String _updatedAt;
  String _streetAddress;
  String _country;
  String _city;
  String _zip;
  String _houseNo;
  String _apartmentNo;
  String _cmFirebaseToken;

  Customer(
      {int id,
        String name,
        String fName,
        String lName,
        String phone,
        String image,
        String email,
        String emailVerifiedAt,
        String createdAt,
        String updatedAt,
        String streetAddress,
        String country,
        String city,
        String zip,
        String houseNo,
        String apartmentNo,
        String cmFirebaseToken}) {
    this._id = id;
    this._name = name;
    this._fName = fName;
    this._lName = lName;
    this._phone = phone;
    this._image = image;
    this._email = email;
    this._emailVerifiedAt = emailVerifiedAt;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._streetAddress = streetAddress;
    this._country = country;
    this._city = city;
    this._zip = zip;
    this._houseNo = houseNo;
    this._apartmentNo = apartmentNo;
    this._cmFirebaseToken = cmFirebaseToken;
  }

  int get id => _id;
  String get name => _name;
  String get fName => _fName;
  String get lName => _lName;
  String get phone => _phone;
  String get image => _image;
  String get email => _email;
  String get emailVerifiedAt => _emailVerifiedAt;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get streetAddress => _streetAddress;
  String get country => _country;
  String get city => _city;
  String get zip => _zip;
  String get houseNo => _houseNo;
  String get apartmentNo => _apartmentNo;
  String get cmFirebaseToken => _cmFirebaseToken;

  Customer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _image = json['image'];
    _email = json['email'];
    _emailVerifiedAt = json['email_verified_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _streetAddress = json['street_address'];
    _country = json['country'];
    _city = json['city'];
    _zip = json['zip'];
    _houseNo = json['house_no'];
    _apartmentNo = json['apartment_no'];
    _cmFirebaseToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['image'] = this._image;
    data['email'] = this._email;
    data['email_verified_at'] = this._emailVerifiedAt;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['street_address'] = this._streetAddress;
    data['country'] = this._country;
    data['city'] = this._city;
    data['zip'] = this._zip;
    data['house_no'] = this._houseNo;
    data['apartment_no'] = this._apartmentNo;
    data['cm_firebase_token'] = this._cmFirebaseToken;
    return data;
  }
}

class Shop {
  int _id;
  String _name;
  String _address;
  String _contact;
  String _image;
  String _createdAt;
  String _updatedAt;

  Shop(
      {int id,
        String name,
        String address,
        String contact,
        String image,
        String createdAt,
        String updatedAt}) {
    this._id = id;
    this._name = name;
    this._address = address;
    this._contact = contact;
    this._image = image;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  String get name => _name;
  String get address => _address;
  String get contact => _contact;
  String get image => _image;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Shop.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _address = json['address'];
    _contact = json['contact'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['address'] = this._address;
    data['contact'] = this._contact;
    data['image'] = this._image;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
