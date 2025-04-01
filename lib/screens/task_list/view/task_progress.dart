import 'package:community/base_view.dart';
import 'package:community/screens/task_list/viewmodel/task_progress_viewmodel.dart';
import 'package:flutter/material.dart';


class TaskProgress extends StatelessWidget{
  final String referenceName;
  final String empId;
  TaskProgress({super.key,
    required this.referenceName,
    required this.empId
  });

  Widget _wrapper({Widget? child}){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1,color: Colors.grey)
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context){
    return BaseView<TaskProgressViewModel>(
      onModelReady: (model) async {
        model.getTaskProgressSummary(referenceName);
      },
      onModelClose: (model) async {

      },
      builder: (context,model,child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(5),
            child: (model.taskProgressData.isEmpty) ?
            const SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Text('No Update Found...'),
              ),
            ) :
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(model.taskProgressData.length, (index){
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: _wrapper(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width*0.25,
                                      child: const Text('Date:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                    Expanded(
                                      child: Text(
                                        model.taskProgressData[index]['tps_date'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width*0.25,
                                      child: const Text('Update:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    ),
                                    Expanded(
                                      child: Text(
                                        model.taskProgressData[index]['tps_update'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              ],
                            )
                        ),
                      );
                    })
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