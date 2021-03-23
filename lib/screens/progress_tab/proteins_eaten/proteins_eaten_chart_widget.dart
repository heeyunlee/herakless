import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/progress_tab/proteins_eaten/protein_entries_screen.dart';

import '../../../constants.dart';

class ProteinsEatenChartWidget extends StatefulWidget {
  final User user;

  const ProteinsEatenChartWidget({Key key, this.user}) : super(key: key);

  @override
  _ProteinsEatenChartWidgetState createState() =>
      _ProteinsEatenChartWidgetState();
}

class _ProteinsEatenChartWidgetState extends State<ProteinsEatenChartWidget> {
  int touchedIndex;

  List<DateTime> _dates;
  List<String> _daysOfTheWeek;

  @override
  void initState() {
    super.initState();
    // Create list of 7 days
    _dates = List<DateTime>.generate(7, (index) {
      var now = DateTime.now();
      return DateTime.utc(now.year, now.month, now.day - index);
    });
    // Create list of 7 days of the week
    _daysOfTheWeek = List<String>.generate(
      7,
      (index) => DateFormat.E().format(_dates[index]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: CardColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => ProteinEntriesScreen.show(
                  context,
                  user: widget.user,
                ),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.restaurant_menu_rounded,
                            color: Colors.greenAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text('Eat Proteins',
                              style: Subtitle1w900GreenAc),
                          const Spacer(),
                          Row(
                            children: [
                              const Text('More', style: ButtonTextGrey),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Getting your protein is as important as working out!',
                        style: BodyText2,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final amount =
                                double.parse((rod.y / 1.05).toStringAsFixed(1));
                            final formattedAmount = Format.proteins(amount);

                            return BarTooltipItem(
                              '$formattedAmount g',
                              BodyText1Black,
                            );
                          },
                        ),
                        touchCallback: (barTouchResponse) {
                          setState(() {
                            if (barTouchResponse.spot != null &&
                                barTouchResponse.touchInput
                                    is! PointerExitEvent &&
                                barTouchResponse.touchInput
                                    is! PointerUpEvent) {
                              touchedIndex =
                                  barTouchResponse.spot.touchedBarGroupIndex;
                            } else {
                              touchedIndex = -1;
                            }
                          });
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => BodyText2,
                          margin: 16,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return '${_daysOfTheWeek[6]}';
                              case 1:
                                return '${_daysOfTheWeek[5]}';
                              case 2:
                                return '${_daysOfTheWeek[4]}';
                              case 3:
                                return '${_daysOfTheWeek[3]}';
                              case 4:
                                return '${_daysOfTheWeek[2]}';
                              case 5:
                                return '${_daysOfTheWeek[1]}';
                              case 6:
                                return '${_daysOfTheWeek[0]}';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          margin: 24,
                          reservedSize: 24,
                          getTextStyles: (value) => BodyText2Grey,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return '0g';
                              case 50:
                                return '50g';
                              case 100:
                                return '100g';
                              case 150:
                                return '150g';
                              default:
                                return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups:
                          (widget.user.dailyNutritionHistories.isNotEmpty)
                              ? _barGroupsChild(widget.user)
                              : randomData(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    int x,
    double y,
    double width = 16,
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 0.05 * y : y,
          colors: isTouched ? [Colors.green] : [Colors.greenAccent],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 160,
            colors: [CardColorLight],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _barGroupsChild(User user) {
    // ignore: omit_local_variable_types
    List<DailyNutritionHistory> historiesFromFirebase =
        user.dailyNutritionHistories;

    var sevenDayHistory = List<DailyNutritionHistory>.generate(7, (index) {
      if (historiesFromFirebase.isNotEmpty) {
        var matchingHistory = historiesFromFirebase
            .where((element) => element.date.toUtc() == _dates[index]);
        // ignore: omit_local_variable_types
        double proteins =
            (matchingHistory.isEmpty) ? 0 : matchingHistory.first.totalProteins;

        return DailyNutritionHistory(
          date: _dates[index],
          totalProteins: proteins,
        );
      }
      return null;
    });
    sevenDayHistory = sevenDayHistory.reversed.toList();

    return [
      _makeBarChartGroupData(
        x: 0,
        y: sevenDayHistory[0].totalProteins,
        isTouched: touchedIndex == 0,
      ),
      _makeBarChartGroupData(
        x: 1,
        y: sevenDayHistory[1].totalProteins,
        isTouched: touchedIndex == 1,
      ),
      _makeBarChartGroupData(
        x: 2,
        y: sevenDayHistory[2].totalProteins,
        isTouched: touchedIndex == 2,
      ),
      _makeBarChartGroupData(
        x: 3,
        y: sevenDayHistory[3].totalProteins,
        isTouched: touchedIndex == 3,
      ),
      _makeBarChartGroupData(
        x: 4,
        y: sevenDayHistory[4].totalProteins,
        isTouched: touchedIndex == 4,
      ),
      _makeBarChartGroupData(
        x: 5,
        y: sevenDayHistory[5].totalProteins,
        isTouched: touchedIndex == 5,
      ),
      _makeBarChartGroupData(
        x: 6,
        y: sevenDayHistory[6].totalProteins,
        isTouched: touchedIndex == 6,
      ),
    ];
  }

  List<BarChartGroupData> randomData() {
    return [
      _makeBarChartGroupData(x: 0, y: 120, isTouched: touchedIndex == 0),
      _makeBarChartGroupData(x: 1, y: 100, isTouched: touchedIndex == 1),
      _makeBarChartGroupData(x: 2, y: 140, isTouched: touchedIndex == 2),
      _makeBarChartGroupData(x: 3, y: 145, isTouched: touchedIndex == 3),
      _makeBarChartGroupData(x: 4, y: 90, isTouched: touchedIndex == 4),
      _makeBarChartGroupData(x: 5, y: 152.2, isTouched: touchedIndex == 5),
      _makeBarChartGroupData(x: 6, y: 160, isTouched: touchedIndex == 6),
    ];
  }
}
