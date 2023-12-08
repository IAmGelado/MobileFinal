import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_faculdade/controllers/analise_treino_controller.dart';


class BarChartCustom extends StatelessWidget {
  BarChartCustom(
      {Key? key,
      required this.title,
      required this.sections})
      : super(key: key);

  List<ChartSection> sections;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 17)),
        const SizedBox(
          height: 30,
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: BarChart(
                      BarChartData(
                    barTouchData: BarTouchData(
                      enabled: false,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: getTitles,
                          reservedSize: 38,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey),
                    ),
                    barGroups: List.generate(sections.length, (i) {
                      return makeGroupData(i, sections[i].value,
                          width: 30);
                    }),
                    minY: 0,
                    maxY: getMaxValue() + 10,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 10,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Colors.grey,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return const FlLine(
                          color: Colors.grey,
                          strokeWidth: 1,
                        );
                      },
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 22,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
            toY: y,
            color: Colors.blue,
            width: width,
            borderRadius: BorderRadius.circular(100)),
      ],
      showingTooltipIndicators: [],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(sections[value.toInt()].title,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          )),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    String text;

    if (value == 0) {
      text = '0';
    } else if (value == getMaxValue() / 2) {
      text = (getMaxValue().toInt() ~/ 2).toString();
    } else if (value == getMaxValue()) {
      text = '${getMaxValue().toInt()}';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: Text(text, style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      )),
    );
  }

  double getMaxValue() {
    double maxValue = 0;

    for (var e in sections) {
      if (e.value >= maxValue) {
        maxValue = e.value;
      }
    }

    return maxValue;
  }
}
