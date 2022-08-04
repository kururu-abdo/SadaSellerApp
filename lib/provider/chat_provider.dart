import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/body/MessageBody.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
import 'package:sixvalley_vendor_app/data/repository/chat_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo chatRepo;
  ChatProvider({@required this.chatRepo});


  List<MessageModel> _chatList;
  List<Customer> _customerList;
  List<List<MessageModel>> _customersMessages;
  bool _isSendButtonActive = false;

  List<MessageModel> get chatList => _chatList;
  List<Customer> get customerList => _customerList;
  bool get isSendButtonActive => _isSendButtonActive;
  List<List<MessageModel>> get customersMessages => _customersMessages;


  Future<void> initCustomerInfo(BuildContext context) async {
    _customerList = null;
    notifyListeners();
    ApiResponse apiResponse = await chatRepo.getChatList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _customerList = [];
      apiResponse.response.data.forEach((chat) => _customerList.add(Customer.fromJson(chat)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }


  Future<void> initChatList(BuildContext context) async {
    ApiResponse apiResponse = await chatRepo.getChatList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _chatList = [];
      _customerList = [];
      _customersMessages = [];
      List<int> _customerIdList = [];
      List<dynamic> _data = apiResponse.response.data.reversed.toList();
      _data.forEach((chat) {
        MessageModel _message = MessageModel.fromJson(chat);
        _chatList.add(_message);
        if(_message.customer!=null){
          if(!_customerIdList.contains(_message.customer.id)) {
            _customerList.add(_message.customer);
            _customerIdList.add(_message.customer.id);
            _customersMessages.add([]);
          }
          _customersMessages[_customerIdList.indexOf(_message.customer.id)].add(_message);
        }

      });

    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }


  void sendMessage(MessageBody messageBody, int customerIndex, BuildContext context) async {
    ApiResponse apiResponse = await chatRepo.sendMessage(messageBody);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _chatList.add(MessageModel(
        sellerId: int.parse(messageBody.userId), message: messageBody.message, sentByCustomer: 0, sentBySeller: 1,
        createdAt: DateConverter.localDateToIsoString(DateTime.now()),
      ));
      _customersMessages[customerIndex].add(MessageModel(
        sellerId: int.parse(messageBody.userId), message: messageBody.message, sentByCustomer: 0, sentBySeller: 1,
        createdAt: DateConverter.localDateToIsoString(DateTime.now()),
      ));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isSendButtonActive = false;
    notifyListeners();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

}
