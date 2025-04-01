import 'package:community/screens/monthly_data/widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class PieChartView extends StatefulWidget {
  int presentDays;
  int absentDays;
  int leaveDays;
  int holidays;
  int partialDays;
  int totalWorkingDays;
  PieChartView({
      required this.presentDays,
      required this.absentDays,
      required this.leaveDays,
      required this.holidays,
      required this.partialDays,
      required this.totalWorkingDays,
      super.key}
      );


  @override
  State<StatefulWidget> createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: CustomPaint(
            painter: PieChartPainter(
              data: {
              'Present': double.parse(widget.presentDays.toString()),
              'Absent': double.parse(widget.absentDays.toString()),
              'Leave': double.parse(widget.leaveDays.toString()),
              'Holiday': double.parse(widget.holidays.toString()),
              'Partial' : double.parse((widget.totalWorkingDays - (widget.presentDays+widget.absentDays+widget.leaveDays+widget.holidays)).toString())
              },
              totalDays: widget.totalWorkingDays
            ),
          ),
        ),
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle
          ),
          child: Center(
            child: FittedBox(
              child: Text('Total Days \n ${widget.totalWorkingDays}',style: TextStyle(color: Color(0xFF006CB5),fontSize: 16,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
            ),
          ),
        )
      ],
    );
  }
}