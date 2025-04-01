import 'dart:convert';

import 'package:community/base_viewmodel.dart';
import 'package:community/locator/locator.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/monthly_data/api_requests/web_requests.dart';
import 'package:community/screens/monthly_data/cache/monthly_data_cache.dart';
import 'package:flutter/material.dart';

import '../constants/monthly_data_constants.dart';

class MonthlyDataViewModel extends BaseViewModel{
  String selectedDate = "";
  String selectedValue = 'Calendar';
  List<Map<String,dynamic>> data = [];
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  var currentDate = DateTime.now();
  var daysPresent = 0;
  var daysAbsent = 0;
  var daysLeave = 0;
  var daysPartial = 0;
  var totalDays = 0;
  List<Map<String,String>> current_holidays = [];
  int totalNoOfDaysInTheMonth = 0;
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();

  void initValues() {
    selectedDate = "";
    selectedValue = 'Calendar';
    month = DateTime.now().month;
    year = DateTime.now().year;
    currentDate = DateTime.now();
    daysPresent = 0;
    daysAbsent = 0;
    daysPartial = 0;
    daysLeave = 0;
    totalDays = 0;
    current_holidays = [];
    totalNoOfDaysInTheMonth = 0;
    data = [];
  }

  int daysInMonth(DateTime date){
    var firstDayThisMonth = DateTime(date.year, date.month);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
    totalNoOfDaysInTheMonth = firstDayNextMonth.difference(firstDayThisMonth).inDays;
    return totalNoOfDaysInTheMonth;
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Calendar", child: Text("Calendar")),
      //DropdownMenuItem(child: Text("Card"),value: "Card"),
      const DropdownMenuItem(value: "Chart", child: Text("Pie Chart")),
      //DropdownMenuItem(child: Text("Graph"),value: "Graph"),
      //const DropdownMenuItem(value: "Holiday", child: Text("Holiday")),
    ];
    return menuItems;
  }

  void setDateAndGetMonthlyData(int month,int year,bool force){
    selectedDate = "${months[month-1]}, $year";
    notifyListeners();
    getMonthlyData(
        startDate: "$year-$month-01",
        endDate: "$year-$month-${daysInMonth(DateTime(year,month))}",
        force: force
    );
  }


  void getMonthlyData({
    String? startDate,
    String? endDate,
    required bool force
  }) async{
    dynamic empData;
    var tempDetails = await MonthlyDataCache().getMonthlyAttendanceFromCache(startDate!, endDate!);
    if(tempDetails == false || force){
      tempDetails = await WebRequests().getMonthlyAttendance(startDate,endDate,homeScreenViewModel.name) ?? [];
      await MonthlyDataCache().putMonthlyDataInCache(startDate, endDate, tempDetails);
      tempDetails = jsonEncode(tempDetails);
    }
    if(jsonDecode(tempDetails).isNotEmpty){
      empData = jsonDecode(tempDetails);
    } else{
      empData = [];
    }
    calculateAttendance(empData);
  }

  void calculateAttendance(empData) {
    if(empData.isEmpty){
      return;
    }
    List<String> keys = List<String>.from(empData["keys"]);
    List<List<dynamic>> values = List<List<dynamic>>.from(empData["values"]);

    List<Map<String, dynamic>> mappedData = values.map((record) {
      return {for (int i = 0; i < keys.length && i < record.length; i++) keys[i]: record[i]};
    }).toList();

    daysPresent = 0;
    daysAbsent = 0;
    daysLeave = 0;
    daysPartial = 0;
    if(mappedData.isNotEmpty){
      for(int i=0; i<mappedData.length; i++){
        totalDays++;
        if(mappedData[i]['status'] == 'Present'){
          daysPresent += 1;
        }else if(mappedData[i]['status'] == 'Absent'){
          daysAbsent += 1;
        }else if(mappedData[i]['status'] == 'On Leave'){
          daysLeave += 1;
        } else{
          daysPartial += 1;
        }
        data.add({
          "name" : mappedData[i]['employee_name'],
          "day" : DateTime.parse(mappedData[i]['attendance_date']).day,
          "status" : mappedData[i]['status'],
          "in_time" : mappedData[i]['in_time'],
          "out_time" : mappedData[i]['out_time'],
          "hours_worked" : mappedData[i]['working_hours'],
          "date": mappedData[i]['attendance_date']
        });
      }
    }
    notifyListeners();
  }

  void sortCurrentMonthHoliday(holidays,month){
    for(int i=0; i<holidays.length; i++){
      if(DateTime.parse(holidays[i]['holiday_date']).month == month){
        current_holidays.add({
          'holiday_date':holidays[i]['holiday_date'],
          'description':holidays[i]['description']
        });
      }
    }
    notifyListeners();
  }

  Future<void> getHolidays(int month,int year) async{
    year = year - 1; //for testing purpose
    totalNoOfDaysInTheMonth = daysInMonth(DateTime(year,month));
    current_holidays.clear();
    WebRequests().getMonthlyHolidays(homeScreenViewModel.holiday_list_name,month,year).then((value) => sortCurrentMonthHoliday(value,month));
  }

  void changeViewSelector(newValue){
    selectedValue = newValue;
    notifyListeners();
  }
}