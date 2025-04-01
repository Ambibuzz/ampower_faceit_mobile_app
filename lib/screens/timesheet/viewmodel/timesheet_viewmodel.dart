import 'package:community/base_viewmodel.dart';
import 'package:community/screens/timesheet/api_requests/web_requests.dart';
import 'package:flutter/material.dart';

class TimesheetViewModel extends BaseViewModel{
  bool isExpenseDataAvailable = true;
  String selectedValue = 'All';
  List<dynamic> timesheet_list = [];
  TextEditingController filterDate = TextEditingController(text: 'Date');

  void clearFields() {
    selectedValue = 'All';
    filterDate = TextEditingController(text: 'Date');
    getTimesheetData();
  }

  void getTimesheetData() async{
    timesheet_list.clear();
    timesheet_list = await WebRequests().getTimesheetListWithoutFilter() ?? [];
    notifyListeners();
  }

  void getTimesheetDataFromStatus(String status) async{
    timesheet_list.clear();
    String filter = status != 'All' ? '["Timesheet","status","=","$status"]' : '';
    timesheet_list = await WebRequests().getTimesheetList(filter) ?? [];
    notifyListeners();
  }

  void getTimesheetDataFromStatusAndDate(String status,String date) async{
    timesheet_list.clear();
    String filter = status != 'All' ? '["Timesheet","status","=","$status"],["Timesheet","start_date","=","$date"]' : '["Timesheet","start_date","=","$date"]';
    timesheet_list = await WebRequests().getTimesheetList(filter) ?? [];
    notifyListeners();
  }


  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "All", child: Text("All")),
      const DropdownMenuItem(value: "Draft", child: Text("Draft")),
      const DropdownMenuItem(value: "Submitted", child: Text("Submitted")),
      const DropdownMenuItem(value: "Billed", child: Text("Billed")),
      const DropdownMenuItem(value: "Payslip", child: Text("Payslip")),
      const DropdownMenuItem(value: "Completed", child: Text("Completed")),
      const DropdownMenuItem(value: "Cancelled", child: Text("Cancelled")),
    ];
    return menuItems;
  }

}