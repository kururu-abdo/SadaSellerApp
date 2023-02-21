import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';

class TransactionChart extends StatefulWidget {
  final List<double> earnings;
  final List<double> commissions;
  final double max;
  TransactionChart({@required this.earnings,@required this.commissions, @required this.max});

  @override
  State<StatefulWidget> createState() => TransactionChartState();
}

class TransactionChartState extends State<TransactionChart> {
  final Color leftBarColor = const Color(0xff4E9BF0);
  final Color rightBarColor = const Color(0xFFFF6969);
  final double width = 5;

   List<BarChartGroupData> rawBarGroups;
   List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, widget.commissions[0],  widget.earnings[0]);
    final barGroup2 = makeGroupData(1, widget.commissions[1],  widget.earnings[1]);
    final barGroup3 = makeGroupData(2, widget.commissions[2], widget.earnings[2]);
    final barGroup4 = makeGroupData(3, widget.commissions[3],  widget.earnings[3]);
    final barGroup5 = makeGroupData(4, widget.commissions[4], widget.earnings[4]);
    final barGroup6 = makeGroupData(5, widget.commissions[5], widget.earnings[5]);
    final barGroup7 = makeGroupData(6, widget.commissions[6],  widget.earnings[6]);
    final barGroup8 = makeGroupData(7, widget.commissions[7], widget.earnings[7]);
    final barGroup9 = makeGroupData(8, widget.commissions[8], widget.earnings[8]);
    final barGroup10 = makeGroupData(9, widget.commissions[9], widget.earnings[9]);
    final barGroup11 = makeGroupData(10, widget.commissions[10], widget.earnings[10]);
    final barGroup12 = makeGroupData(11, widget.commissions[11], widget.earnings[11]);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
      barGroup8,
      barGroup9,
      barGroup10,
      barGroup11,
      barGroup12,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Container(width: Dimensions.ICON_SIZE_LARGE,height: Dimensions.ICON_SIZE_LARGE ,
                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Image.asset(Images.monthly_earning)),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                  Text(getTranslated('monthly_earning', context), style: robotoBold.copyWith(
                      color: ColorResources.getTextColor(context),
                      fontSize: Dimensions.FONT_SIZE_LARGE),),

                ],),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                  children: [Row(children: [
                    Icon(Icons.circle,size: Dimensions.ICON_SIZE_SMALL,
                        color: Color(0xFF4E9BF0)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                    Text(getTranslated('your_earnings', context),
                      style: robotoSmallTitleRegular.copyWith(color: ColorResources.getTextColor(context),
                    fontSize: Dimensions.FONT_SIZE_DEFAULT),),],),

                    SizedBox(width : Dimensions.PADDING_SIZE_SMALL,),

                    Row(children: [
                      Icon(Icons.circle,size: Dimensions.ICON_SIZE_SMALL,
                          color: Color(0xFFFF6969)),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                      Text(getTranslated('commission_given', context),
                           style: robotoSmallTitleRegular.copyWith(color: ColorResources.getTextColor(context),
                               fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),
                       ],
                     ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: widget.max + 2000,
                  barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.grey,
                        getTooltipItem: (_a, _b, _c, _d) => null,
                      ),
                      touchCallback: (FlTouchEvent event, response) {
                        if (response == null || response.spot == null) {
                          setState(() {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                          });
                          return;
                        }

                        touchedGroupIndex = response.spot.touchedBarGroupIndex;

                        setState(() {
                          if (!event.isInterestedForInteractions) {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                            return;
                          }
                          showingBarGroups = List.of(rawBarGroups);
                          if (touchedGroupIndex != -1) {
                            var sum = 0.0;
                            for (var rod in showingBarGroups[touchedGroupIndex].barRods) {
                              sum += rod.y;
                            }
                            final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;

                            showingBarGroups[touchedGroupIndex] =
                                showingBarGroups[touchedGroupIndex].copyWith(
                                  barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                    return rod.copyWith(y: avg);
                                  }).toList(),
                                );
                          }
                        });
                      }),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                          color: Color(0xff7589a2), fontWeight: FontWeight.w400, fontSize: 10),
                      margin: 10,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Jan';
                          case 1:
                            return 'Feb';
                          case 2:
                            return 'Mar';
                          case 3:
                            return 'Apr';
                          case 4:
                            return 'May';
                          case 5:
                            return 'Jun';
                          case 6:
                            return 'Jul';
                          case 7:
                            return 'Aug';
                          case 8:
                            return 'Sep';
                          case 9:
                            return 'Oct';
                          case 10:
                            return 'Nov';
                          case 11:
                            return 'Dec';
                          default:
                            return '';
                        }
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 1.5;
    const space = 1.5;
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}


// class TransactionChart extends StatefulWidget {
//   final List<double> earnings;
//   final List<double> commissions;
//   final double maxValue;
//   const TransactionChart({Key key, this.earnings, this.commissions, this.maxValue}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => TransactionChartState();
// }
//
// class TransactionChartState extends State<TransactionChart> {
//   final Color leftBarColor = const Color(0xff4E9BF0);
//   final Color rightBarColor = const Color(0xFFFF6969);
//   final double width = 5;
//
//
//    List<BarChartGroupData> rawBarGroups;
//    List<BarChartGroupData> showingBarGroups;
//
//   int touchedGroupIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     final barGroup1 = makeGroupData(0, widget.commissions[0],  widget.earnings[0]);
//     final barGroup2 = makeGroupData(1, widget.commissions[1],  widget.earnings[1]);
//     final barGroup3 = makeGroupData(2, widget.commissions[2], widget.earnings[2]);
//     final barGroup4 = makeGroupData(3, widget.commissions[3],  widget.earnings[3]);
//     final barGroup5 = makeGroupData(4, widget.commissions[4], widget.earnings[4]);
//     final barGroup6 = makeGroupData(5, widget.commissions[5], widget.earnings[5]);
//     final barGroup7 = makeGroupData(6, widget.commissions[6],  widget.earnings[6]);
//     final barGroup8 = makeGroupData(7, widget.commissions[7], widget.earnings[7]);
//     final barGroup9 = makeGroupData(8, widget.commissions[8], widget.earnings[8]);
//     final barGroup10 = makeGroupData(9, widget.commissions[9], widget.earnings[9]);
//     final barGroup11 = makeGroupData(10, widget.commissions[10], widget.earnings[10]);
//     final barGroup12 = makeGroupData(11, widget.commissions[11], widget.earnings[11]);
//
//     final items = [
//       barGroup1,
//       barGroup2,
//       barGroup3,
//       barGroup4,
//       barGroup5,
//       barGroup6,
//       barGroup7,
//       barGroup8,
//       barGroup9,
//       barGroup10,
//       barGroup11,
//       barGroup12,
//     ];
//
//     rawBarGroups = items;
//
//     showingBarGroups = rawBarGroups;
//     showingBarGroups = rawBarGroups;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         color: const Color(0xffFaFbFc),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//
//                   Row(children: [
//                     Container(width: Dimensions.ICON_SIZE_LARGE,height: Dimensions.ICON_SIZE_LARGE ,
//                         child: Image.asset(Images.monthly_earning)),
//                     SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
//
//                     Text(getTranslated('monthly_earning', context), style: robotoRegular.copyWith(
//                         color: ColorResources.getTextColor(context),
//                         fontSize: Dimensions.FONT_SIZE_LARGE),),
//
//                   ],),
//                   SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
//
//                   Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
//                     children: [Row(children: [
//                       Icon(Icons.circle,size: Dimensions.ICON_SIZE_SMALL,
//                           color: ColorResources.mainCardOneColor(context)),
//                       Text(getTranslated('your_earnings', context),
//                         style: robotoSmallTitleRegular.copyWith(color: ColorResources.getTextColor(context),
//                             fontSize: Dimensions.FONT_SIZE_DEFAULT),),],),
//
//                       SizedBox(width : Dimensions.PADDING_SIZE_SMALL,),
//
//                       Row(children: [
//                         Icon(Icons.circle,size: Dimensions.ICON_SIZE_SMALL,
//                             color: ColorResources.mainCardThreeColor(context)),
//                         Text(getTranslated('commission_given', context),
//                           style: robotoSmallTitleRegular.copyWith(color: ColorResources.getTextColor(context),
//                               fontSize: Dimensions.FONT_SIZE_SMALL),
//                         ),
//                       ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 38,
//               ),
//               Expanded(
//                 child: BarChart(
//                   BarChartData(
//                     maxY: widget.maxValue,
//                     barTouchData: BarTouchData(
//                         touchTooltipData: BarTouchTooltipData(
//                           tooltipBgColor: Colors.grey,
//                           getTooltipItem: (_a, _b, _c, _d) => null,
//                         ),
//                         touchCallback: (FlTouchEvent event, response) {
//                           if (response == null || response.spot == null) {
//                             setState(() {
//                               touchedGroupIndex = -1;
//                               showingBarGroups = List.of(rawBarGroups);
//                             });
//                             return;
//                           }
//
//                           touchedGroupIndex =
//                               response.spot.touchedBarGroupIndex;
//
//                           setState(() {
//                             if (!event.isInterestedForInteractions) {
//                               touchedGroupIndex = -1;
//                               showingBarGroups = List.of(rawBarGroups);
//                               return;
//                             }
//                             showingBarGroups = List.of(rawBarGroups);
//                             if (touchedGroupIndex != -1) {
//                               var sum = 0.0;
//                               for (var rod
//                               in showingBarGroups[touchedGroupIndex]
//                                   .barRods) {
//                                 sum += rod.toY;
//                               }
//                               final avg = sum /
//                                   showingBarGroups[touchedGroupIndex]
//                                       .barRods
//                                       .length;
//
//                               showingBarGroups[touchedGroupIndex] =
//                                   showingBarGroups[touchedGroupIndex].copyWith(
//                                     barRods: showingBarGroups[touchedGroupIndex]
//                                         .barRods
//                                         .map((rod) {
//                                       return rod.copyWith(toY: avg);
//                                     }).toList(),
//                                   );
//                             }
//                           });
//                         }),
//                     titlesData: FlTitlesData(
//                       show: true,
//                       rightTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       topTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: bottomTitles,
//                           reservedSize: 42,
//                         ),
//                       ),
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           reservedSize: 30,
//                           interval: 1,
//                           getTitlesWidget: leftTitles,
//                         ),
//                       ),
//                     ),
//                     borderData: FlBorderData(
//                       show: false,
//                     ),
//                     barGroups: showingBarGroups,
//                     gridData: FlGridData(show: false),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget leftTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Color(0xff7589a2),
//       fontWeight: FontWeight.normal,
//       fontSize: 14,
//     );
//     String text;
//     if (value == 1000) {
//       text = '1K';
//     } else if (value == 5000) {
//       text = '5K';
//     } else if (value == 10000) {
//       text = '10K';
//     }else if (value == 20000) {
//       text = '20K';
//     } else if (value == 30000) {
//       text = '30K';
//     }else if (value == 40000) {
//       text = '40K';
//     }
//     else if (value == 50000) {
//       text = '50K';
//     }else if (value == 60000) {
//       text = '60K';
//     }else if (value == 80000) {
//       text = '80K';
//     }
//     else if (value == 100000) {
//       text = '100K';
//     }else if (value == 150000) {
//       text = '150K';
//     }else if (value == 200000) {
//       text = '200K';
//     }
//     else {
//       return Container();
//     }
//     return Text(text, style: style);
//   }
//
//   Widget bottomTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Color(0xff7589a2),
//       fontWeight: FontWeight.normal,
//       fontSize: Dimensions.FONT_SIZE_SMALL,
//     );
//     Widget text;
//     switch (value.toInt()) {
//       case 0:
//         text = const Text(
//           'Jan',
//           style: style,
//         );
//         break;
//       case 1:
//         text = const Text(
//           'Feb',
//           style: style,
//         );
//         break;
//       case 2:
//         text = const Text(
//           'Mar',
//           style: style,
//         );
//         break;
//       case 3:
//         text = const Text(
//           'Apr',
//           style: style,
//         );
//         break;
//       case 4:
//         text = const Text(
//           'May',
//           style: style,
//         );
//         break;
//       case 5:
//         text = const Text(
//           'June',
//           style: style,
//         );
//         break;
//       case 6:
//         text = const Text(
//           'July',
//           style: style,
//         );
//         break;
//       case 7:
//         text = const Text(
//           'Aug',
//           style: style,
//         );
//         break;
//       case 8:
//         text = const Text(
//           'Sep',
//           style: style,
//         );
//         break;
//       case 9:
//         text = const Text(
//           'Oct',
//           style: style,
//         );
//         break;
//       case 10:
//         text = const Text(
//           'Nov',
//           style: style,
//         );
//         break;
//       case 11:
//         text = const Text(
//           'Dec',
//           style: style,
//         );
//         break;
//       default:
//         text = const Text(
//           '',
//           style: style,
//         );
//         break;
//     }
//     return Padding(padding: const EdgeInsets.only(top: 20), child: text);
//   }
//
//   BarChartGroupData makeGroupData(int x, double y1, double y2) {
//     return BarChartGroupData(barsSpace: 4, x: x, barRods: [
//       BarChartRodData(
//         toY: y1,
//         color: leftBarColor,
//         width: width,
//       ),
//       BarChartRodData(
//         toY: y2,
//         color: rightBarColor,
//         width: width,
//       ),
//     ]);
//   }
//
//   Widget makeTransactionsIcon() {
//     const width = 4.5;
//     const space = 3.5;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           width: width,
//           height: 10,
//           color: Colors.white.withOpacity(0.4),
//         ),
//         const SizedBox(
//           width: space,
//         ),
//         Container(
//           width: width,
//           height: 28,
//           color: Colors.white.withOpacity(0.8),
//         ),
//         const SizedBox(
//           width: space,
//         ),
//         Container(
//           width: width,
//           height: 42,
//           color: Colors.white.withOpacity(1),
//         ),
//         const SizedBox(
//           width: space,
//         ),
//         Container(
//           width: width,
//           height: 28,
//           color: Colors.white.withOpacity(0.8),
//         ),
//         const SizedBox(
//           width: space,
//         ),
//         Container(
//           width: width,
//           height: 10,
//           color: Colors.white.withOpacity(0.4),
//         ),
//       ],
//     );
//   }
// }