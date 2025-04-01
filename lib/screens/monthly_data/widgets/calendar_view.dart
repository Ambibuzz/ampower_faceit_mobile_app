import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget{
  final data;
  final month;
  final year;
  const CalendarView({super.key,
    this.data,
    this.year,
    this.month,
  });
  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>{

  late Map<DateTime, String> attendanceData;

  @override
  void initState() {
    super.initState();
    attendanceData = _getAttendanceData();
  }


  @override
  void didUpdateWidget(covariant CalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    attendanceData = _getAttendanceData();
    setState(() {

    });
  }

  Map<DateTime, String> _getAttendanceData() {
    final Map<DateTime, String> attendanceData = {};

    for (var record in widget.data) {
      DateTime date = DateTime.parse(record['date']);
      String status = record['status'] ?? 'Unknown';
      attendanceData[date] = status;
    }

    return attendanceData;
  }

  // Get the status for a specific date
  String? _getAttendanceStatus(DateTime day) {
    return attendanceData[DateTime(day.year, day.month, day.day)];
  }

  // Customize how each day is displayed
  Widget _buildDayWidget(BuildContext context, DateTime day, DateTime focusedDay) {
    String? status = _getAttendanceStatus(day);
    Color statusColor;

    switch (status) {
      case 'Present':
        statusColor = Color(0xFF189333); // Green for present
        break;
      case 'Absent':
        statusColor = Color(0xFFC52F2F); // Red for absent
        break;
      case 'On Leave':
        statusColor = Color(0xFF006CB5); // Orange for leave
        break;
      default:
        statusColor = Colors.transparent; // Default (no status)
    }

    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: statusColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: statusColor == Colors.transparent ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){

    return Column(
      children: [
        TableCalendar(
          headerVisible: false,
          firstDay: DateTime(1970, 1, 1),
          lastDay: DateTime(2050),
          focusedDay: DateTime(widget.year,widget.month),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) =>
                _buildDayWidget(context, day, focusedDay),
            todayBuilder: (context, day, focusedDay) => _buildDayWidget(context, day, focusedDay),
            selectedBuilder: (context, day, focusedDay) => Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
