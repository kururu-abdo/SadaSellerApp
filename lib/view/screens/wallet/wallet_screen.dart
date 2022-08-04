import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/provider/transaction_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_edit_dialog.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/base/title_row.dart';
import 'package:sixvalley_vendor_app/view/screens/transaction/transaction_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/wallet/widget/wallet_card.dart';
import 'package:sixvalley_vendor_app/view/screens/wallet/widget/wallet_transaction_list_view.dart';

class WalletScreen extends StatefulWidget {
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<ThemeProvider>(context, listen: false).darkTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: getTranslated('wallet', context)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<TransactionProvider>(context, listen: false).getTransactionList(context);
          },
          backgroundColor: Theme.of(context).primaryColor,


          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      child: Container(padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),

                        color: Theme.of(context).cardColor,
                        alignment: Alignment.center,
                        child:Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width/2.5,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                              margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                boxShadow: [BoxShadow(color: Colors.grey[darkMode ? 900 : 200],
                                    spreadRadius: 0.5, blurRadius: 0.3)],
                              ),

                            ),
                            Container(width: MediaQuery.of(context).size.width-70,height: MediaQuery.of(context).size.width/2.5,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor.withOpacity(.10),
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width/2.5))
                              ),),
                            Consumer<ProfileProvider>(
                                builder: (context, seller, child) {
                                  return Container(
                                    height: MediaQuery.of(context).size.width/2.5,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                    margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container (
                                                width: Dimensions.LOGO_HEIGHT,
                                                height: Dimensions.LOGO_HEIGHT,
                                                child: Image.asset(Images.card_white)),
                                            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(getTranslated('balance_withdraw', context),
                                                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                        color: Colors.white)),
                                                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                                                Text(PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ?
                                                seller.userInfoModel.wallet.totalEarning ?? 0 : 0),
                                                    style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white,
                                                        fontSize: Dimensions.FONT_SIZE_WITHDRAWABLE_AMOUNT)),
                                              ],
                                            ),
                                            SizedBox(width: Dimensions.LOGO_HEIGHT,),
                                          ],
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),
                                        InkWell(
                                          child: Container(height: 40,width: 250,
                                            decoration: BoxDecoration(color: Color(0xFFEEF6FF),
                                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                              InkWell(onTap: () => showModalBottomSheet(
                                                  backgroundColor: Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context, builder: (_) => CustomEditDialog()),
                                                child: Text(getTranslated('send_withdraw_request', context),
                                                    style:titilliumRegular.copyWith(color: Theme.of(context).primaryColor,
                                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                              ),

                                            ],),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ],
                        ),
                      ))),


              SliverToBoxAdapter(
                child: Column(children: [
                  Consumer<ProfileProvider>(
                      builder: (context, seller, child) {
                        return Container(child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Row(children: [
                              Expanded(child: WalletCard(
                                amount: '${PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ?
                                seller.userInfoModel.wallet.withdrawn : 0)}',

                                title: '${getTranslated('withdrawn', context)}',
                                color: ColorResources.withdrawCardColor(context),)),

                              Expanded(child: WalletCard(
                                amount: '${PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ?
                                seller.userInfoModel.wallet.pendingWithdraw : 0)}',

                                title: '${getTranslated('pending_withdrawn', context)}',
                                color: ColorResources.pendingCardColor(context),)),

                            ],),
                          ),



                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Row(children: [
                              Expanded(child: WalletCard(
                                amount: '${PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ?
                                seller.userInfoModel.wallet.commissionGiven : 0)}',

                                title: '${getTranslated('commission_given', context)}',
                                color: ColorResources.commissionCardColor(context),)),

                              Expanded(child: WalletCard(
                                amount: '${PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ?
                                seller.userInfoModel.wallet.deliveryChargeEarned : 0)}',

                                title: '${getTranslated('delivery_charge_earned', context)}',
                                color: ColorResources.deliveryChargeCardColor(context),)),

                            ],),
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Row(children: [
                              Expanded(child: WalletCard(
                                amount: '${PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ?
                                seller.userInfoModel.wallet.collectedCash : 0)}',

                                title: '${getTranslated('collected_cash', context)}',
                                color: ColorResources.collectedCashCardColor(context),)),

                              Expanded(child: WalletCard(
                                amount: '${PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ?
                                seller.userInfoModel.wallet.totalTaxCollected : 0)}',

                                title: '${getTranslated('total_collected_tax', context)}',
                                color: ColorResources.collectedTaxCardColor(context),)),

                            ],),
                          ),
                        ],),);
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TitleRow(title: getTranslated('withdraw_history', context),
                    isPrimary: true,
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionScreen())),),
                  ),

                  Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, child) {
                        return  Container(
                          child: transactionProvider.transactionList !=null ? transactionProvider.transactionList.length > 0 ?
                          WalletTransactionListView(transactionProvider: transactionProvider) : NoDataScreen()
                              : Center(child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                        );
                      }
                  ),

                ],)
              )
            ],


          ),
        ),
      ),

    );

  }
}
class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 180;

  @override
  double get minExtent => 180;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 180 || oldDelegate.minExtent != 180 || child != oldDelegate.child;
  }
}

