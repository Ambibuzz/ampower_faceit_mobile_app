import 'dart:typed_data';
import 'package:community/base_view.dart';
import 'package:community/locator/locator.dart';
import 'package:community/router/routing_constants.dart';
import 'package:community/screens/home/cache/home_cache.dart';
import 'package:community/screens/home/homewidgets/attendance_details_widget.dart';
import 'package:community/screens/home/homewidgets/quick_link_widget.dart';
import 'package:community/service/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../homewidgets/checkin_widget.dart';
import '../homewidgets/sitecheckin_widget.dart';
import '../homewidgets/upcoming_holiday_widget.dart';
import '../viewmodel/homescreen_viewmodel.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BaseView<HomeScreenViewModel>(
      onModelReady: (model) async{
        bool isSupported = await model.auth.isDeviceSupported();
        model.changeSupportState(isSupported);
        model.initApp(false);
      },
      builder: (context, model, child){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: 20,
            leading: Container(),
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    //Text('${designation} | ',style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.normal),),
                    Text(
                      model.empId,
                      style: const TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await HomeCache().deleteCache('EmployeeData');
                  model.initApp(true);
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
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                  child: model.image == null
                      ? Image.asset('assets/images/user.png')
                      : ClipOval(
                    child: Image.memory(
                      Uint8List.fromList(model.image),
                      fit: BoxFit.fill,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: model.isLoading
              ? const Center(
            child: Text('Loading'),
          )
              : model.restrictUser
              ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/smartphone.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Your License has expired. Please contact us at buzz.us@ambibuzz.com.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
              : !model.employee
              ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/smartphone.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Please contact HR for employee permissions.')
              ],
            ),
          )
              : SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async{

              },
              child: Container(
                color: const Color(0xFFE6F0F8),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 15, left: 18, right: 18),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 1.0,
                            spreadRadius: 1, //New
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    model.getSalutation(model.name.split(' ')[0]),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  // Spacer(),
                                  // InkWell(
                                  //   onTap: () {
                                  //     model.changeCheckinState();
                                  //     return;
                                  //   },
                                  //   child: Container(
                                  //     height: 30,
                                  //     width: 30,
                                  //     decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: Color(0xFF006CB5)
                                  //     ),
                                  //     child: Icon(Icons.add,color: Colors.white,),
                                  //   ),
                                  // )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              model.checkinString == 'IN'
                                  ? const Text(
                                'Please checkin.',
                                style:
                                TextStyle(fontSize: 12),
                              )
                                  : const Text(
                                'Please checkout.',
                                style:
                                TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                           CheckinWidget(
                            name: model.name,
                            empId: model.empId,
                            checkinString: model.checkinString,
                            recentCheckin: model.getRecentCheckin,
                            model: model,
                          ),
                          model.isSiteCheckin
                              ? SiteCheckinWidget(
                            name: model.name,
                            empId: model.empId,
                            checkinString: model.checkinString,
                            recentCheckin: model.getRecentCheckin,
                            model: model,
                          )
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: const Text(
                        'Quick Links',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    QuickLinkWidget(),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: const Text(
                        'Your Attendance Details',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    AttendanceDetailsWidget(),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: const Text(
                        'Upcoming Holidays',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    UpcomingHolidayWidget(),
                    const SizedBox(
                      height: 10,
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