import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/data/model/body/MessageBody.dart';
import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
import 'package:sixvalley_vendor_app/provider/chat_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/widget/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final Customer customer;
  final int customerIndex;
  final List<MessageModel> messages;
  ChatScreen({@required this.customer, @required this.customerIndex, @required this.messages});

  final ImagePicker picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Consumer<ChatProvider>(builder: (context, chat, child) {
        return Column(children: [

          CustomAppBar(title: customer.fName+' '+customer.lName),

          // Chats
          Expanded(child: chat.chatList != null ? messages.length != 0 ? ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemCount: messages.length,
            reverse: true,
            itemBuilder: (context, index) {
              List<MessageModel> chats = messages.reversed.toList();
              return MessageBubble(chat: chats[index], customerImage: customer.image);
            },
          ) : SizedBox.shrink() : ChatShimmer()),

          // Bottom TextField
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 65,
                child: Card(
                  color: Theme.of(context).highlightColor,
                  shadowColor: Colors.grey[200],
                  elevation: 2,
                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: Row(children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: titilliumRegular,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              hintText: 'Type here...',
                              hintStyle: titilliumRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR),
                              border: InputBorder.none,
                            ),
                            onChanged: (String newText) {
                              if(newText.isNotEmpty && !Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                                Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                              }else if(newText.isEmpty && Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                                Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                              }
                            },
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            if(Provider.of<ChatProvider>(context, listen: false).isSendButtonActive){
                              MessageBody messageBody = MessageBody(sellerId: customer.id.toString(), message: _controller.text.trim());
                              Provider.of<ChatProvider>(context, listen: false).sendMessage(messageBody, customerIndex, context);
                              _controller.text = '';
                            }
                          },
                          child: Container(width: Dimensions.ICON_SIZE_LARGE,height: Dimensions.ICON_SIZE_LARGE,
                            child: Image.asset(
                              Images.send,
                              color: Provider.of<ChatProvider>(context).isSendButtonActive ? Theme.of(context).primaryColor : ColorResources.HINT_TEXT_COLOR,

                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ]);
      }),
    );
  }
}

class ChatShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (context, index) {

        bool isMe = index%2 == 0;
        return Shimmer.fromColors(
          baseColor: isMe ? Colors.grey[300] : ColorResources.IMAGE_BG,
          highlightColor: isMe ? Colors.grey[100] : ColorResources.IMAGE_BG.withOpacity(0.9),
          enabled: Provider.of<ChatProvider>(context).chatList == null,
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              isMe ? SizedBox.shrink() : InkWell(child: CircleAvatar(child: Icon(Icons.person))),
              Expanded(
                child: Container(
                  margin: isMe ?  EdgeInsets.fromLTRB(50, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 50, 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                        bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: isMe ? ColorResources.IMAGE_BG : ColorResources.WHITE
                  ),
                  child: Container(height: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

