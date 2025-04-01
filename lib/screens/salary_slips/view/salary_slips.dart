import 'package:community/base_view.dart';
import 'package:community/components/global_styles/text_field_design.dart';
import 'package:community/screens/salary_slips/viewmodel/salary_slip_viewmodel.dart';
import 'package:community/screens/salary_slips/widgets/salary_slip_strip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'salary_slip_details.dart';

class SalarySlip extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BaseView<SalarySlipViewModel>(
      onModelReady: (model) async {
        model.getSalarySlipsBasedonFilters('');
        model.calculateDates();
      },
      onModelClose: (model) async {
        model.clearFields();
      },
      builder: (context,model,child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text('Salary Slips History',style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        builder: (btmSheetContext){
                          return StatefulBuilder(
                            builder: (context, StateSetter btmSheetState){
                              return SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                  ),
                                  child: Wrap(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height:6,
                                            width: 60,
                                            margin: const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[600]
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          SizedBox(
                                            height: 50,
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(width: 1,color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                    value: model.selectedValue,
                                                    onChanged: (String? newValue){
                                                      btmSheetState(() {
                                                        model.selectedValue = newValue!;
                                                      });
                                                    },
                                                    items: model.dropdownItems
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(width: 1,color: Colors.grey),
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: DropdownButtonHideUnderline(child: DropdownButton<int>(
                                                    value: model.selectedYear,
                                                    items: List.generate(
                                                      10,
                                                          (index) => DateTime.now().year - index,
                                                    ).map((year) {
                                                      return DropdownMenuItem(
                                                        value: year,
                                                        child: Text(year.toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (year) {
                                                      btmSheetState(() {
                                                        model.selectedYear = year!;
                                                        model.calculateDates();
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  )),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(width: 1,color: Colors.grey),
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: DropdownButtonHideUnderline(child: DropdownButton<int>(
                                                    value: model.selectedMonth,
                                                    items: List.generate(12, (index) => index + 1).map((month) {
                                                      return DropdownMenuItem(
                                                        value: month,
                                                        child: Text(DateFormat.MMMM().format(DateTime(0, month))),
                                                      );
                                                    }).toList(),
                                                    onChanged: (month) {
                                                      btmSheetState(() {
                                                        model.selectedMonth = month!;
                                                        model.calculateDates();
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    model.getSalarySlipsBasedonFilters('["Salary Slip","status","=","${model.selectedValue}"],["Salary Slip","start_date","=","${model.startDate}"],["Salary Slip","end_date","=","${model.endDate}"],["Salary Slip","payroll_frequency","=","Monthly"]');
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: const Color(0xFF006CB5)
                                                    ),
                                                    child: const Center(
                                                      child: Text('Done',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    model.clearFields();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: const Color(0xFF006CB5)
                                                    ),
                                                    child: const Center(
                                                      child: Text('Clear',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10,)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                    );
                  },
                  icon: const Icon(Icons.filter_alt,color: Color(0xFF006CB5),size: 30,)
              ),
            ],
          ),
          body: model.salaryslip_list.isNotEmpty
              ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(model.salaryslip_list.length, (index) {
                    return InkWell(
                      onTap: (){
                        showModalBottomSheet(
                            context: Get.context!,
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
                                    child: SalarySlipDetails(docName: model.salaryslip_list[index]['name'].toString()),
                                  );
                                },
                              );
                            }
                        );
                      },
                      child: SalarySlipStrip(
                          name: model.salaryslip_list[index]['name'].toString(),
                          postingDate: model.salaryslip_list[index]['posting_date'].toString(),
                          netPay: model.salaryslip_list[index]['net_pay'].toString(),
                          status: model.salaryslip_list[index]['status'].toString()
                      ),
                    );
                  })

                ],
              ),
            ),
          ):SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/empty.png',height: 140,),
                const SizedBox(height: 10,),
                const Text('No Salary Slips Found',style: TextStyle(color: Colors.grey),),
                const SizedBox(height:10,),
              ],
            ),
          )
        );
      },
    );
  }
}