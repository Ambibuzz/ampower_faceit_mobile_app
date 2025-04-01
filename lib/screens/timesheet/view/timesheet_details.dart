import 'package:community/base_view.dart';
import 'package:community/screens/timesheet/api_requests/web_requests.dart';
import 'package:community/screens/timesheet/viewmodel/timesheetdetails_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';
import 'add_timesheet.dart';

class TimeSheetDetails extends StatelessWidget{
  var name;
  TimeSheetDetails({super.key, 
     this.name
});

  @override
  Widget build(BuildContext context){
    return BaseView<TimeSheetDetailsViewModel>(
      onModelReady: (model) async {
        model.getCustomers('Customer','Timesheet');
        model.getCurrency('Currency', 'Timesheet');
        model.getTimesheetData(name);
      },
      onModelClose: (model) async {
        model.customerMenuItems.clear();
        model.currencyMenuItems.clear();
        model.projectMenuItems.clear();
      },
      builder: (context,model,child) {
        return Scaffold(
          body: model.timesheetData == null ?
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(child: CupertinoActivityIndicator(),),
          ):
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: model.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            enabled: false,
                            initialValue: model.timesheetData['employee'],
                            decoration: inputDecoration('Employee', true),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            enabled: false,
                            initialValue: model.timesheetData['employee_name'],
                            decoration: inputDecoration('Employee Name', false),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                          width: double.infinity,
                          decoration: textFieldDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: model.selectedCustomer,
                                onChanged: (String? newValue){
                                  model.changeCustomer(newValue);
                                },
                                items: model.customerMenuItems
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                          width: double.infinity,
                          decoration: textFieldDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: model.selectedCurrency,
                                onChanged: (String? newValue){
                                  model.changeCustomer(newValue);
                                },
                                items: model.currencyMenuItems
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            enabled: false,
                            initialValue: 'Draft',
                            decoration: inputDecoration('Status', false),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                          width: double.infinity,
                          decoration: textFieldDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: model.selectedProject,
                                onChanged: (String? newValue){
                                  model.changeSelectedProject(newValue);
                                },
                                items: model.projectMenuItems
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            enabled: false,
                            initialValue: model.timesheetData['company'],
                            decoration: inputDecoration('Company', true),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text('Timesheets'),
                        const SizedBox(height: 5,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: 800,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: Table(
                                border: TableBorder.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                children:[
                                  TableRow( children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(children:[Text('Activity Type',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('From Date',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('To Date',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('Expected Hrs',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(children:[Text('Hrs',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('Is Billable',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('Is Completed',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Icon(Icons.settings,size: 16,)]
                                      ),
                                    )
                                  ],
                                  ),
                                  ...List.generate(model.timesheets.length,(index) {
                                    return TableRow( children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children:[Text('${model.timesheets[index]['activity_type']}',style: const TextStyle(fontSize: 12),)]),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children:[Text('${model.timesheets[index]['from_date']}',style: const TextStyle(fontSize: 12),)]),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            children:[Text('${model.timesheets[index]['to_date']}',style: const TextStyle(fontSize: 12),)]
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            children:[Text('${model.timesheets[index]['expected_hrs']}',style: const TextStyle(fontSize: 12),)]
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            children:[Text('${model.timesheets[index]['hrs']}',style: const TextStyle(fontSize: 12),)]
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            children:[Text('${model.timesheets[index]['is_billable']}',style: const TextStyle(fontSize: 12),)]
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            children:[Text('${model.timesheets[index]['is_completed']}',style: const TextStyle(fontSize: 12),)]
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            children:[
                                              InkWell(
                                                onTap: (){
                                                  // Get.to(() => EditAddTimeSheet(selectedProject: selectedProject,timesheets: timesheets,index: index))!.then((value) => setState((){
                                                  //
                                                  // }));
                                                },
                                                child: const Icon(Icons.edit,size: 16,),
                                              )
                                            ]
                                        ),
                                      ),
                                    ],
                                    );
                                  })
                                ]
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        InkWell(
                          onTap: (){
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isDismissible: true,
                                builder: (btmSheetContext){
                                  return StatefulBuilder(
                                    builder: (context, StateSetter btmSheetState){
                                      return Container(
                                        height: MediaQuery.sizeOf(context).height,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                        ),
                                        child: AddTimeSheet(selectedProject: model.selectedProject),
                                      );
                                    },
                                  );
                                }
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: textFieldDecoration(),
                            child: const Text('Add Row'),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                if(model.formKey.currentState!.validate()){
                                  var totalHours = 0.0;
                                  for(int i=0; i<model.timesheets.length; i++){
                                    totalHours += double.parse(model.timesheets[i]['hrs'].toString());
                                  }
                                  Map<String,dynamic> timeSheetData = {
                                    "name": name,
                                    "company": model.timesheetData['company'],
                                    "currency": model.selectedCurrency,
                                    "status": 'Draft',
                                    "total_hours": totalHours,
                                    "time_logs": [
                                      for(int i=0; i<model.timesheets.length; i++){
                                        "completed": model.timesheets[i]['is_completed'],
                                        "is_billable": model.timesheets[i]['is_billable'],
                                        "activity_type": model.timesheets[i]['activity_type'],
                                        "from_time": model.timesheets[i]['from_date'],
                                        "hours": double.parse(model.timesheets[i]['hrs']),
                                        "to_time": model.timesheets[i]['to_date'],
                                        "project": model.selectedProject == '-' ? '' : model.selectedProject,
                                        "task": model.timesheets[i]['task'] == '-' ? '': model.timesheets[i]['task']
                                      }
                                    ],

                                    "employee": model.timesheetData['employee'],
                                    "employee_name": model.timesheetData['employee_name'],
                                    "customer": model.selectedCustomer
                                  };

                                  WebRequests().editTimeSheet(timeSheetData).then((value) => {
                                    if(value!['success']){
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          content: SizedBox(
                                            height: 260,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Text("Success!",style: TextStyle(color: Color(0xFF10C500),fontSize: 30 ),),
                                                const SizedBox(height: 20,),
                                                Image.asset('assets/images/checkmark.png',height: 80,width: 80,),
                                                const SizedBox(height: 20,),
                                                const Text('Timesheet Edited Succesfully!',textAlign: TextAlign.center,),
                                                const SizedBox(height: 20),
                                                InkWell(
                                                  onTap: (){
                                                    //Get.to(() => const TimeSheet());
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: const Color(0xFF9DFFB2),
                                                    ),

                                                    child: const Center(
                                                      child: Text("Done",style: TextStyle(color: Colors.black),),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    }else{
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Something went wrong"),
                                          content: Text(value['data'].split(':')[1].trim()),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Container(
                                                color: const Color(0xFF9DFFB2),
                                                padding: const EdgeInsets.all(14),
                                                child: const Text("ok",style: TextStyle(color: Colors.black),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      //fluttertoast(context, value['data'])
                                    }
                                  });

                                }else{
                                  fluttertoast(context, 'Something went wrong');
                                }


                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFF006CB5),
                                ),
                                child: const Center(
                                  child: Text('Save',style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        );
      },
    );

  }
}