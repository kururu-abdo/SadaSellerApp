import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

import 'painter/line_dashed_painter.dart';

class CustomStepper extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLastItem;
  CustomStepper({@required this.title, @required this.color, this.isLastItem = false});

  @override
  Widget build(BuildContext context) {
    Color myColor;
      myColor = color;
    return Container(
      height: isLastItem ? 50 : 100,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: CircleAvatar(backgroundColor: myColor, radius: 10.0),
              ),
              Text(title, style: titilliumRegular)
            ],
          ),
          isLastItem
              ? SizedBox.shrink()
              : Padding(
            padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL, left: Dimensions.PADDING_SIZE_LARGE),
            child: CustomPaint(painter: LineDashedPainter(myColor)),
          ),
        ],
      ),
    );
  }
}