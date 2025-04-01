import 'dart:typed_data';
import 'package:community/base_view.dart';
import 'package:community/locator/locator.dart';
import 'package:community/router/routing_constants.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/notification/viewmodel/notification_viewmodel.dart';
import 'package:community/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../../home/cache/home_cache.dart';


class NotificationPage extends StatelessWidget{
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();

  @override
  Widget build(BuildContext context){
    return BaseView<NotificationViewModel>(
      onModelReady: (model) async{
        model.getNoteList();
      },
      onModelClose: (model) async{

      },
      builder: (context,model,child){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(homeScreenViewModel.name,style: const TextStyle(color: Colors.black,fontSize: 18),),
                Row(
                  children: [
                    Text(homeScreenViewModel.empId,style: const TextStyle(color: Color(0xFF1E88E5),fontSize: 14,fontWeight: FontWeight.bold),)
                  ],
                )
              ],
            ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await HomeCache().deleteCache('EmployeeData');
                    homeScreenViewModel.initApp(true);
                    Get.snackbar(
                      'Syncing...',
                      'Please wait while we sync all your data.',
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
                  icon: const Icon(Icons.refresh, color: Color(0xFF006CB5), size: 24),
                ),
                IconButton(
                  onPressed: () {
                    locator.get<NavigationService>().navigateTo(notificationScreen);
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Color(0xFF006CB5),
                    size: 24,
                  ),
                ),
                InkWell(
                  onTap: () {
                    locator.get<NavigationService>().navigateTo(profileScreen);
                  },
                  child: Container(
                    width: 60,
                    padding:
                    const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    child: homeScreenViewModel.image == null
                        ? Image.asset('assets/images/user.png')
                        : ClipOval(
                      child: Image.memory(
                        Uint8List.fromList(homeScreenViewModel.image),
                        fit: BoxFit.fill,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                )
              ]
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: model.notelist.isNotEmpty ?
            SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(model.notelist.length, (index) {
                    return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isDismissible: true,
                            builder: (btmSheetContext){
                              return StatefulBuilder(
                                builder: (context, StateSetter btmSheetState){
                                  return Container(
                                    height: MediaQuery.sizeOf(context).height*0.6,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          HtmlWidget(model.notelist[index]['content']),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width:100,
                                                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15),
                                                        color: const Color(0xFF006CB5)
                                                    ),
                                                    child: const Center(
                                                      child: Text('Done',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                        );
                      },
                      child: Container(
                        //margin: const EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.grey
                            )
                          )
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1,color: Colors.grey)
                            ),
                            child: Icon(Icons.menu_book,color: Color(0xFF006CB5),),
                          ),
                          title: Text(model.notelist[index]['title']),
                          trailing: Container(
                            padding: const EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                            decoration: BoxDecoration(
                                color: model.notelist[index]['public'] == 1 ? Colors.green : Colors.redAccent,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: model.notelist[index]['public'] == 1 ? const Text('Public',style: TextStyle(color: Colors.white),): const Text('Private',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ):
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10,),
                const Text('No new notifications')
              ],
            ),
          ),
        );
      },
    );
  }
}