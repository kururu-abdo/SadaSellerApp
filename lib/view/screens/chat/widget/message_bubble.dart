import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel chat;
  final String customerImage;
  MessageBubble({@required this.chat, @required this.customerImage});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat.sentByCustomer == 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isMe ? SizedBox.shrink() :
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_LARGE),
            child: InkWell(child: ClipOval(child: Container(
              color: Theme.of(context).highlightColor,
              child: CachedNetworkImage(
                errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image, height: Dimensions.chat_image,
                  width: Dimensions.chat_image,fit: BoxFit.cover,),
                placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/$customerImage',
                height: Dimensions.chat_image,
                width: Dimensions.chat_image,
                fit: BoxFit.cover,
              ),
            ))),
          ),
          Flexible(
            child: Column(crossAxisAlignment: isMe ?CrossAxisAlignment.end:CrossAxisAlignment.start,
              children: [
                Container(
                    margin: isMe ?  EdgeInsets.fromLTRB(70, 5, 10, 5) : EdgeInsets.fromLTRB(10, 10, 10, 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: isMe? Radius.circular(0) : Radius.circular(15),
                        bottomLeft: isMe ? Radius.circular(15) : Radius.circular(0),
                        bottomRight: isMe ? Radius.circular(0) : Radius.circular(15),
                        topRight: isMe? Radius.circular(15): Radius.circular(0),
                      ),
                      color: isMe ? ColorResources.getPrimary(context) : ColorResources.getPrimary(context).withOpacity(.10),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      chat.message.isNotEmpty ? Text(chat.message,
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                               color: isMe ?
                               Theme.of(context).cardColor: ColorResources.getTextColor(context))) : SizedBox.shrink(),
                    ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(chat.createdAt)),
                      style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: ColorResources.getHint(context),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
