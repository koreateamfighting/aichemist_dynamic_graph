import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math' as math;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MainView(),
      ),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainView createState() => _MainView();
}

class _MainView extends State<MainView> {
  late List<StockData> stockData;
  late ChartSeriesController _chartSeriesController;
  String stockName = '';
  int time = 35;
  int flag = 0; // 0 : none ,1: 삼성 , 2: tesla
  int samsung_minimum = 75000;
  int samsung_maximum = 78000;
  int tesla_minimum = 140;
  int tesla_maximum = 160;
  int minimum = 0;
  int maximum = 1;
  int interval = 1;
  void updateDataSource(Timer timer) {
    if(flag == 1){
      stockData.add(StockData(time++, (math.Random().nextInt(3000) + 75000)));
    }
    else if(flag ==2){
      stockData.add(StockData(time++, (math.Random().nextInt(20) + 140)));
    }

    stockData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: stockData.length - 1, removedDataIndex: 0);
  }
  List<StockData> getChartData_Samsung() {
    return  [
      StockData(0, 76000),
      StockData(5, 77000),
      StockData(10, 76800),
      StockData(15, 76500),
      StockData(20, 77200),
      StockData(25, 77300),
      StockData(30, 77100),
      StockData(35, 77500),
    ];
  }

  List<StockData> getChartData_Tesla() {
    return  [
      StockData(0, 150.0),
      StockData(5, 152.0),
      StockData(10, 151.0),
      StockData(15, 158.0),
      StockData(20, 160.0),
      StockData(25, 154.0),
      StockData(30, 148.0),
      StockData(35, 146.0),
    ];
  }

  void setInterval(){
    if(flag==1){
      minimum = samsung_minimum;
      maximum = samsung_maximum;
      interval= 100;

    }
    else if(flag == 2){
      minimum = tesla_minimum;
      maximum = tesla_maximum;
      interval= 1;

    }
    else{
      minimum = 0;
      maximum = 1;
      interval= 1;
    }
  }

  void initState() {
    super.initState();
    stockData = [];
    Timer.periodic(const Duration(seconds: 5), updateDataSource);

  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text('주식 도표'),
          ),
          backgroundColor: Colors.greenAccent),
      body: Center(
          child: Column(
        children: [
          SizedBox(height: 30),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500),
              child: Column(children: [
                Container(
                    child: SfCartesianChart(

                  legend: Legend(isVisible: true),
                  // trackballBehavior: _trackballBehavior,
                  series: <LineSeries<StockData, int>>[
                    LineSeries<StockData, int>(
                      onRendererCreated: (ChartSeriesController controller) {
                        _chartSeriesController = controller;
                      },
                      dataSource: stockData,
                      xValueMapper: (StockData data, _) => data.time,
                      yValueMapper: (StockData data, _) => data.price,
                      name: stockName,
                      markerSettings: MarkerSettings(isVisible: true),
                    )
                  ],
                  primaryXAxis: NumericAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 5,
                      title: AxisTitle(text: 'Time (seconds)')),
                  primaryYAxis:
                  NumericAxis(
                      minimum: minimum.toDouble(),
                      maximum: maximum.toDouble(),
                      interval: interval.toDouble(),
                      numberFormat:
                          NumberFormat.simpleCurrency(decimalDigits: 0)),
                )),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.greenAccent, // background
                    //   onPrimary: Colors.black, // foreground
                    // ),
                    onPressed: () {
                      setState(() {
                        flag = 1;
                        setInterval();
                        stockData = getChartData_Samsung();
                        stockName = '삼전';
                        // _trackballBehavior = TrackballBehavior(
                        //     enable: true,
                        //     activationMode: ActivationMode.singleTap);
                      });
                    },
                    child: Text('삼성'),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(

                    onPressed: () {
                      setState(() {

                        flag = 2;
                        setInterval();
                        stockData = getChartData_Tesla();
                        stockName = '테슬라';
                      });
                    },
                    child: Text('테슬라'),
                  ),
                ),
              ]))
        ],
      )),
    );
  }

}
class StockData {
  StockData(this.time, this.price);

  final int time;
  final double price;
}
