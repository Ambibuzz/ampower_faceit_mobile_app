import 'dart:convert';

import 'package:community/base_viewmodel.dart';
import 'package:community/screens/salary_slips/api_requests/web_requests.dart';
import 'package:community/screens/salary_slips/cache/salary_slip_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class SalarySlipViewModel extends BaseViewModel{
  String selectedValue = 'Submitted';
  List<dynamic> salaryslip_list = [];
  List<dynamic> allSalaryslip_list = [];
  TextEditingController filterDate = TextEditingController(text: 'Date');
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  String startDate = '';
  String endDate = '';


  void calculateDates() {
    DateTime firstDay = DateTime(selectedYear, selectedMonth, 1);
    DateTime lastDay = DateTime(selectedYear, selectedMonth + 1, 0);
    startDate = DateFormat('yyyy-MM-dd').format(firstDay);
    endDate = DateFormat('yyyy-MM-dd').format(lastDay);
    notifyListeners();
  }

  void changeSelectedYear(year) {
    selectedYear = year;
    notifyListeners();
  }

  void changeSelectedMonth(month) {
    selectedMonth = month;
    notifyListeners();
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Draft", child: Text("Draft")),
      const DropdownMenuItem(value: "Submitted", child: Text("Submitted")),
      const DropdownMenuItem(value: "Cancelled", child: Text("Cancelled")),
    ];
    return menuItems;
  }

  void clearFields() {
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
    startDate = '';
    endDate = '';
    selectedValue = 'Submitted';
    filterDate = TextEditingController(text: 'Date');
    getSalarySlipsBasedonFilters('');
  }


  Future<void> getSalarySlipsBasedonFilters(filters) async {
    dynamic salarySlips = await WebRequests().getSalarySlipList(filters);
    salaryslip_list = salarySlips['data'];
    notifyListeners();
  }


}