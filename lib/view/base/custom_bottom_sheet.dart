import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:joseeder_seller/provider/theme_provider.dart';
import 'package:joseeder_seller/utill/color_resources.dart';
import 'package:joseeder_seller/utill/dimensions.dart';
import 'package:joseeder_seller/utill/styles.dart';

class CustomBottomSheet extends StatelessWidget {
  final String image;
  final String title;
  final Widget widget;
  CustomBottomSheet({ @required this.image, @required this.title, @required this.widget,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_)=>widget));
      },

      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorResources.getBottomSheetColor(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
              spreadRadius: 0.5, blurRadius: 0.3)],
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Container(width: MediaQuery.of(context).size.width/14,
              height: MediaQuery.of(context).size.width/14,
              child: Image.asset(image),),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Center(child: Text(title,
                textAlign: TextAlign.center,
                maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)
              ),),]),
      ),
    );
  }
}
