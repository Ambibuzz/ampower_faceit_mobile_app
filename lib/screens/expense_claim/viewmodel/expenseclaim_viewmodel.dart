import 'dart:convert';

import 'package:community/base_viewmodel.dart';
import 'package:community/screens/expense_claim/api_requests/web_requests.dart';
import 'package:community/screens/expense_claim/cache/expense_claim_cache.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseClaimViewModel extends BaseViewModel{
  bool isExpenseDataAvailable = true;
  String selectedValue = 'All';
  List<dynamic> expense_list = [];
  List<dynamic> allExpense_list = [];
  TextEditingController from_date = TextEditingController(text: 'From');
  TextEditingController to_date = TextEditingController(text: 'To');


  void clearFields() {
    selectedValue = 'All';
    from_date = TextEditingController(text: 'From');
    to_date = TextEditingController(text: 'To');
    getAllClaims(false);
  }


  void getAllClaims(bool force) async{
    allExpense_list.clear();
    var tempClaims = await ExpenseClaimCache().getAllExpenseClaims();
    if(tempClaims == false || force){
      tempClaims = await WebRequests().getExpenseClaimList('');
      await ExpenseClaimCache().putAllExpenseClaimsInCache(tempClaims['data']);
      allExpense_list = tempClaims['data'];
      getExpenseDataFromStatus(selectedValue,tempClaims['data']);
    } else {
      allExpense_list = jsonDecode(tempClaims);
      getExpenseDataFromStatus(selectedValue,jsonDecode(tempClaims));
    }
  }


  Future<void> getExpenseDataFromStatus(String status,dynamic claims) async{
    expense_list.clear();
    if(status == 'All'){
      expense_list.addAll(claims);
      notifyListeners();
      return;
    }
    for (var element in claims) {
      if(element['status'] == status){
        expense_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getExpenseDataFromStatusAndDate(String status,String fromDate,String toDate,List<dynamic> claims) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime from = format.parse(fromDate);
    DateTime to = format.parse(toDate);
    expense_list.clear();
    if(status == 'All') {
      for (var element in claims) {
        if((DateTime.parse(element['posting_date']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['posting_date']).isBefore(to.add(Duration(days: 1))) )){
          expense_list.add(element);
        }
      }
    } else {
      for (var element in claims) {
        if(element['status'] == status && (DateTime.parse(element['posting_date']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['posting_date']).isBefore(to.add(Duration(days: 1))) )){
          expense_list.add(element);
        }
      }
    }

    notifyListeners();
  }

  Future<void> getExpenseDataFromDate(String fromDate,String toDate,List<dynamic> claims) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime from = format.parse(fromDate);
    DateTime to = format.parse(toDate);
    expense_list.clear();
    for (var element in claims) {
      if((DateTime.parse(element['posting_date']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['posting_date']).isBefore(to.add(Duration(days: 1))) )){
        expense_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getExpenseDataFromFromDate(String fromDate,List<dynamic> claims) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime from = format.parse(fromDate);

    expense_list.clear();
    for (var element in claims) {
      if(DateTime.parse(element['posting_date']).isAfter(from)){
        expense_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getExpenseDataFromToDate(String toDate,List<dynamic> claims) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime to = format.parse(toDate);
    expense_list.clear();
    for (var element in claims) {
      if(DateTime.parse(element['posting_date']).isBefore(to)){
        expense_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getExpenseDataFromStatusAndFromDate(String status,String fromDate,List<dynamic> claims) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime from = format.parse(fromDate);
    expense_list.clear();
    if(status == 'All') {
      for (var element in claims) {
        if(DateTime.parse(element['posting_date']).isAfter(from)){
          expense_list.add(element);
        }
      }
    } else {
      for (var element in claims) {
        if(element['status'] == status && DateTime.parse(element['posting_date']).isAfter(from)){
          expense_list.add(element);
        }
      }
    }
    notifyListeners();
  }

  Future<void> getExpenseDataFromStatusAndToDate(String status,String toDate,List<dynamic> claims) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime to = format.parse(toDate);
    expense_list.clear();
    if(status == 'All') {
      for (var element in claims) {
        if(DateTime.parse(element['posting_date']).isBefore(to)){
          expense_list.add(element);
        }
      }
    } else {
      for (var element in claims) {
        if(element['status'] == status && DateTime.parse(element['posting_date']).isBefore(to)){
          expense_list.add(element);
        }
      }
    }
    notifyListeners();
  }


  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "All", child: Text("All")),
      const DropdownMenuItem(value: "Draft", child: Text("Draft")),
      const DropdownMenuItem(value: "Paid", child: Text("Paid")),
      const DropdownMenuItem(value: "Unpaid", child: Text("Unpaid")),
      const DropdownMenuItem(value: "Submitted", child: Text("Submitted")),
      const DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
      const DropdownMenuItem(value: "Cancelled", child: Text("Cancelled")),
    ];
    return menuItems;
  }
}