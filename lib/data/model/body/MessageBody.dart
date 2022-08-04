class MessageBody {
  String _userId;
  String _message;

  MessageBody({String sellerId, String message}) {
    this._userId = sellerId;
    this._message = message;
  }

  String get userId => _userId;
  String get message => _message;

  MessageBody.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this._userId;
    data['message'] = this._message;
    return data;
  }
}
