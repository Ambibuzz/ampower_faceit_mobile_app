import 'package:community/screens/home/api_requests/web_requests.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as IMGPKR;
import 'dart:io';
import 'package:location/location.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../utils/iamgeCompresssor.dart';
class CheckinWidget extends StatefulWidget{
  final name;
  final empId;
  HomeScreenViewModel model;
  var checkinString;
  Function recentCheckin;
  CheckinWidget({super.key,
    required this.name,
    required this.empId,
    required this.checkinString,
    required this.recentCheckin,
    required this.model
  });
  @override
  State<CheckinWidget> createState() => _CheckinWidgetState();
}

class _CheckinWidgetState extends State<CheckinWidget> with SingleTickerProviderStateMixin{
  final IMGPKR.ImagePicker _picker = IMGPKR.ImagePicker();
  XFile? employeePhoto;
  File? employeePhotoCompressed;
  bool isLocationFetched = false;
  bool isAttendanceMarked = false;
  bool locationStatus = false;
  TextEditingController checkinNote = TextEditingController();
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward(); // Start animation when screen loads
  }


  Future<bool> onShot() async {
    var result = await confirmPicture();
    if(result){
      employeePhotoCompressed = await compressFile(File(employeePhoto!.path));
      return true;
    }
    return false;
  }

  Future<bool> confirmPicture() async{
    employeePhoto = await _picker.pickImage(source: IMGPKR.ImageSource.camera,preferredCameraDevice: IMGPKR.CameraDevice.front);//await _cameraService.takePicture();
    if(employeePhoto != null){
      return true;
    }
    return false;
  }



  Future<List<double>> getLocation() async {
    var location = Location();
    var locationData = await location.getLocation();
    return [
      locationData.latitude ?? 72.584759,
      locationData.longitude ?? 74.584345
    ];
  }


  void _initiateCheckin() async {
    StateSetter? btmSheet;
    var isPictureTaken = await onShot();
    if(isPictureTaken) {
      Map<String, Map<String, dynamic>> bodyData;
      getLocation().then((value) => {
        btmSheet!(() {
          if(value.isNotEmpty){
            isLocationFetched = true;
          }
        }),
        if(value.isNotEmpty){
          bodyData = {
            "data": {
              'employee': widget.empId,
              'face_detected': '',
              "device_id": '${value[0]},${value[1]}',
              "log_type": widget.checkinString,
              "face_detection_status": 1,
              "face_detection_comment": "success",
            }
          },
          WebRequests().checkinUser(bodyData).then((value) => {
            if(value['message']['location_status'] == 1){
              WebRequests().uploadImage(employeePhotoCompressed,value['message']['name'],widget.empId).then((value) => {
                btmSheet!(() {
                  isAttendanceMarked = true;
                  locationStatus = true;
                }),
              }),
              if(checkinNote.text != ''){
                WebRequests().addCheckinComment(checkinNote.text, value['message']['name']).then((value) => {
                  setState(() {
                    checkinNote.text = '';
                  })
                })
              },
              widget.recentCheckin()
            }else{
              btmSheet!(() {
                isAttendanceMarked = true;
                locationStatus = false;
              })
            },
          })
        }
      });
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          builder: (btmSheetContext){
            return StatefulBuilder(
              builder: (context, StateSetter btmSheetState){
                btmSheet = btmSheetState;
                return Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height*0.4,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !isLocationFetched ?
                      const Text('Please wait we\'re fetching your location...'):
                      !isAttendanceMarked ?
                      const Text('Please wait we\'re marking your attendance...'):
                      isAttendanceMarked && !locationStatus?
                      const Text('Location not Matched.'):
                      const Text('Attendance Marked Successfully!'),
                      const SizedBox(height: 20,),
                      !isAttendanceMarked? const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          )

                      ): isAttendanceMarked && !locationStatus?
                      const Icon(Icons.error_outline,color: Colors.red,size: 80,):
                      const Icon(Icons.check_circle_outline_outlined,color: Colors.green,size: 80,),
                      const SizedBox(height: 40,),
                      isAttendanceMarked ?InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width:100,
                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green
                          ),
                          child: const Center(
                            child: Text('Close',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ):Container()
                    ],
                  ),
                );
              },
            );
          }
      ).then((value) => {
        isAttendanceMarked = false,
        locationStatus = false,
        isLocationFetched = false,
      });
    }
}



  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFF006CB5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        widget.model.checkinString == 'IN'
                            ? 'Swipe to Check-in'
                            : 'Swipe to Check-out',
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              SwipeTo(
                  iconOnRightSwipe: Icons.double_arrow,
                  iconOnLeftSwipe: Icons.arrow_back_ios_new_outlined,
                  iconColor: Colors.white,
                  onRightSwipe: (details) {
                    _initiateCheckin();
                  },
                  onLeftSwipe: (details) {
                    _initiateCheckin();
                  },
                  child: Row(
                    mainAxisAlignment: widget.checkinString == 'IN' ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      widget.checkinString == 'IN' ?
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(width: 2,color: const Color(0xFF006CB5) )
                        ),
                        child: Center(
                          child: Icon(Icons.double_arrow,color: const Color(0xFF006CB5)),
                        ),
                      ):
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(width: 2,color: const Color(0xFF006CB5) )
                        ),
                        child: Center(
                          child: RotatedBox(
                              quarterTurns: 2,
                              child: Icon(Icons.double_arrow,color: const Color(0xFF006CB5))
                          ),
                        ),
                      )
                    ],
                  )
              )

            ],
          ),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: textFieldDecoration(),
            child: TextField(
              controller: checkinNote,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              decoration: inputDecoration('Add Note (Optional) max 50 words', false),
            ),
          ),
        ],
      ),
    ) ;
  }
}