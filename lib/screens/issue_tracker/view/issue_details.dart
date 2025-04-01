import 'package:community/base_view.dart';
import 'package:community/screens/issue_tracker/api_requests/web_requests.dart';
import 'package:community/screens/issue_tracker/viewmodel/issuedetails_viewmodel.dart';
import 'package:community/screens/issue_tracker/viewmodel/issuetracker_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';
import '../../../locator/locator.dart';


class IssueDetails extends StatelessWidget{
  final String docName;
  const IssueDetails({super.key, 
    required this.docName
});
  
  @override
  Widget build(BuildContext context){
    return BaseView<IssueDetailsViewModel>(
      onModelReady: (model) async{
        model.getIssueDetails(docName);
      },
      onModelClose: (model) async{

      },
      builder: (context,model,child){
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
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
                              controller: model.subject,
                              decoration: inputDecoration('Subject', true),
                              validator: (value){
                                if(value!.isNotEmpty) {
                                  return null;
                                }
                                return 'Please provide a subject';
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                            width: double.infinity,
                            decoration: textFieldDecoration(),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: model.selectedValueStatus,
                                  onChanged: (String? newValue){
                                    model.changeStatusValue(newValue);
                                  },
                                  items: model.dropdownStatusItems
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
                                  value: model.selectedValuePriority,
                                  onChanged: (String? newValue){
                                    model.changePriorityValue(newValue);
                                  },
                                  items: model.dropdownPriorityItems
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.description,
                              maxLines: 1,
                              decoration: inputDecoration('Description', true),
                              validator: (value){
                                if(value!.isNotEmpty) {
                                  return null;
                                }
                                return 'Please provide a description';
                              },
                            ),
                          ),
                          const SizedBox(height: 20,),
                          InkWell(
                            onTap: (){
                              if(model.formKey.currentState!.validate()){
                                Map<String,String> issueData = {
                                  "status": model.selectedValueStatus,
                                  "priority": model.selectedValuePriority,
                                  "description": model.description.text,
                                  "subject": model.subject.text,
                                };
                                WebRequests().editIssue(issueData,docName).then((value) => {
                                  if(value!['success']){
                                    locator.get<IssueTrackerViewModel>().getIssueListData(),
                                    Get.back()
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
                                              color: const Color(0xFF006CB5),
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("ok",style: TextStyle(color: Colors.white),),
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
                                  color: Color(0xFF006CB5)
                              ),
                              child: const Center(
                                child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}