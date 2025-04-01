import 'package:community/base_view.dart';
import 'package:community/screens/salary_slips/viewmodel/salary_slip_details_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/global_styles/text_field_design.dart';

class SalarySlipDetails extends StatelessWidget{
  final String docName;
  const SalarySlipDetails({super.key, 
    required this.docName
});

  @override
  Widget build(BuildContext context){
    return BaseView<SalarySlipDetailsViewModel>(
      onModelReady: (model) async {
        model.salarySlipDetails = null;
        model.getSalarySlipDetails(false, docName);
      },
      onModelClose: (model) async {

      },
      builder: (context,model,child){
        return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(5),
              child: model.salarySlipDetails == null?const Center(child: CupertinoActivityIndicator(),):
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height:6,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Text(docName,style: const TextStyle(color: Color(0xFF006CB5),fontSize: 18,fontWeight: FontWeight.bold),),
                          Spacer(),
                          IconButton(
                              onPressed: () async{
                                model.downloadSalarySlip(context, docName);
                              },
                              icon: model.showDownloadProgress ? const Icon(Icons.downloading,color: Colors.green,):const Icon(Icons.file_download_outlined,color: Color(0xFF006CB5),)
                          ),
                          InkWell(
                            onTap: () {
                              model.getSalarySlipDetails(true,docName);
                              Get.snackbar(
                                'Syncing...',
                                'Please wait we are syncing the details',
                                backgroundColor: const Color(0xFF006CB5),
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 5),
                                icon: const Icon(
                                  Icons.sync,
                                  color: Colors.white,
                                ),
                                mainButton: TextButton(
                                  onPressed: () => Get.back(), // Close the snackbar if needed
                                  child: const Text(
                                    'Dismiss',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                showProgressIndicator: true, // Shows a linear progress indicator
                                progressIndicatorBackgroundColor: Colors.white24,
                              );
                            },
                            child: Icon(Icons.refresh,color: Color(0xFF006CB5),),
                          )
                        ],
                      ),
                      Form(
                        key: model.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: model.salarySlipDetails['data']['status'],
                                decoration: inputDecoration('Status', false),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: model.salarySlipDetails['data']['employee'],
                                decoration: inputDecoration('Employee ID', false),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: DateFormat('yyyy-MM-dd').format(DateTime.parse(model.salarySlipDetails['data']['start_date'])),
                                decoration: inputDecoration('Start Date', false),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: DateFormat('yyyy-MM-dd').format(DateTime.parse(model.salarySlipDetails['data']['end_date'])),
                                decoration: inputDecoration('End Date', false),
                              ),
                            ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: double.infinity,
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              enabled: false,
                              initialValue: model.salarySlipDetails['data']['total_working_days'].toString(),
                              decoration: inputDecoration('Working Days', false),
                            ),
                          ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: model.salarySlipDetails['data']['gross_pay'].toString(),
                                decoration: inputDecoration('Gross Pay', false),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: model.salarySlipDetails['data']['total_deduction'].toString(),
                                decoration: inputDecoration('Total Deduction(INR)', false),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: model.salarySlipDetails['data']['net_pay'].toString(),
                                decoration: inputDecoration('Net Pay(INR)', false),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text('Earnings'),
                            const SizedBox(height: 5,),
                            Table(
                                border: TableBorder.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                children:[
                                  TableRow( children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('Component',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,))]
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('Amount(INR)',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                      ),
                                    ),
                                  ],
                                  ),
                                  ...List.generate(model.salarySlipDetails['data']['earnings'].length,(index) {
                                    return TableRow( children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children:[Text('${model.salarySlipDetails['data']['earnings'][index]['salary_component']}',style: const TextStyle(fontSize: 12),)]),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children:[Text('₹${model.salarySlipDetails['data']['earnings'][index]['amount']}',style: const TextStyle(fontSize: 12),)]),
                                      )
                                    ],
                                    );
                                  })
                                ]
                            ),
                            const SizedBox(height: 10,),
                            Text('Deductions'),
                            const SizedBox(height: 5,),
                            Table(
                                border: TableBorder.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                children:[
                                  TableRow( children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('Component',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,))]
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Text('Amount(INR)',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                      ),
                                    ),
                                  ],
                                  ),
                                  ...List.generate(model.salarySlipDetails['data']['deductions'].length,(index) {
                                    return TableRow( children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children:[Text('${model.salarySlipDetails['data']['deductions'][index]['salary_component']}',style: const TextStyle(fontSize: 12),)]),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children:[Text('₹${model.salarySlipDetails['data']['deductions'][index]['amount']}',style: const TextStyle(fontSize: 12),)]),
                                      )
                                    ],
                                    );
                                  })
                                ]
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              )
          )
        );
      },
    );
  }
}