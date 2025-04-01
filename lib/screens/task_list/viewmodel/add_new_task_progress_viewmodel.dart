import 'package:community/base_viewmodel.dart';
import 'package:community/screens/task_list/api_requests/web_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewTaskProgressViewModel extends BaseViewModel{
  TextEditingController date = TextEditingController();
  TextEditingController description = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> ownerMenuItems = [];
  var selectedOwner = "";
  var selectedEffort = "";
  var empId;

  void clearFields() {
    date = TextEditingController();
    description = TextEditingController();
    ownerMenuItems = [];
    selectedOwner = "";
    selectedEffort = "";
    notifyListeners();
  }

  List<DropdownMenuItem<String>> get effortMenuItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "", child: Text("")),
      const DropdownMenuItem(value: "0.5", child: Text("0.5")),
      const DropdownMenuItem(value: "1", child: Text("1")),
      const DropdownMenuItem(value: "1.5", child: Text("1.5")),
      const DropdownMenuItem(value: "2", child: Text("2")),
      const DropdownMenuItem(value: "2.5", child: Text("2.5")),
      const DropdownMenuItem(value: "3", child: Text("3")),
      const DropdownMenuItem(value: "3.5", child: Text("3.5")),
      const DropdownMenuItem(value: "4", child: Text("4")),
      const DropdownMenuItem(value: "4.5", child: Text("4.5")),
      const DropdownMenuItem(value: "5", child: Text("5")),
      const DropdownMenuItem(value: "5.5", child: Text("5.5")),
      const DropdownMenuItem(value: "6", child: Text("6")),
      const DropdownMenuItem(value: "6.5", child: Text("6.5")),
      const DropdownMenuItem(value: "7", child: Text("7")),
      const DropdownMenuItem(value: "7.5", child: Text("7.5")),
      const DropdownMenuItem(value: "8", child: Text("8")),
      const DropdownMenuItem(value: "9", child: Text("9")),
      const DropdownMenuItem(value: "10", child: Text("10")),
      const DropdownMenuItem(value: "11", child: Text("11")),
      const DropdownMenuItem(value: "12", child: Text("12")),
    ];
    return menuItems;
  }

  void setEmpId(empId) {
    this.empId = empId;
    notifyListeners();
  }

  void changeOwner(value) {
    selectedOwner = value;
    notifyListeners();
  }

  void changeEffort(value) {
    selectedEffort = value;
    notifyListeners();
  }

  void changeDate(String formattedDate){
    date.text = formattedDate;
    notifyListeners();
  }

  void getOwnerList(String doctype,String referenceDoctype) async{
    var ownerList = await WebRequests().doctypeSearch({
      'doctype':doctype,
      'ref_doctype':referenceDoctype,
      'apply_filter':false,
      'permission': '1'
    });
    var containsOwner = false;
    for(int i=0; i<ownerList.length; i++){
      if(ownerList[i]['value'] == empId){
        containsOwner = true;
        break;
      }
    }
    if(!containsOwner){
      ownerMenuItems.add(DropdownMenuItem(value: empId, child: Text(empId)));
    }
    for(int i=0; i<ownerList.length; i++){
      ownerMenuItems.add(DropdownMenuItem(value: ownerList[i]['value'], child: Text(ownerList[i]['value'])));
    }
    notifyListeners();
  }
}