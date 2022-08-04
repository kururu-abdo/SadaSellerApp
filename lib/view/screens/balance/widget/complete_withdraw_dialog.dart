import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/screens/dashboard/dashboard_screen.dart';

class CompleteOrderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height / 2.3,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, size: 50, color: Theme.of(context).primaryColor,),
            Text( getTranslated('congrats', context),
              style: titilliumRegular.copyWith(fontSize: 22, color: Theme.of(context).primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text( getTranslated('your_withdrawal', context),
                textAlign: TextAlign.center,
                style: titilliumRegular.copyWith(color: ColorResources.GREY, fontSize: 15),
              ),
            ),

           SizedBox(height: 40,),
           Padding(
             padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
             child: CustomButton(btnTxt: getTranslated('go_to_home', context),
                 backgroundColor: ColorResources.WHITE,
               onTap: ()  {
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen()));
               })
           ),
          ],
        ),
      ),
    );
  }
}
