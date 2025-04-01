import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/monthly_data/api_requests/web_requests.dart';
import 'package:community/screens/home/api_requests/web_requests.dart' as HOME;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../utils/iamgeCompresssor.dart';
import 'package:image_picker/image_picker.dart' as IMGPKR;
import 'dart:io';
import 'package:location/location.dart';
class SiteCheckinWidget extends StatefulWidget{
  final name;
  final empId;
  var checkinString;
  Function recentCheckin;
  HomeScreenViewModel model;
  SiteCheckinWidget({super.key,
    required this.name,
    required this.empId,
    required this.checkinString,
    required this.recentCheckin,
    required this.model
  });
  @override
  State<SiteCheckinWidget> createState() => _SiteCheckinWidgetState();
}

class _SiteCheckinWidgetState extends State<SiteCheckinWidget>{
  final IMGPKR.ImagePicker _picker = IMGPKR.ImagePicker();
  XFile? employeePhoto;
  File? employeePhotoCompressed;
  bool isLocationFetched = false;
  bool isAttendanceMarked = false;
  bool locationStatus = false;
  @override
  void initState() {
    _selectedTypeList();
    _getEmployeeList();
    super.initState();
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

  String type = 'Customer';
  List<DropdownMenuItem<String>> get dropdownTypeItems{
    List<DropdownMenuItem<String>> statuses = [
      const DropdownMenuItem(value: "Customer", child: Text("Customer")),
      const DropdownMenuItem(value: "Lead", child: Text("Lead")),
    ];
    return statuses;
  }

  String purpose = 'Sample';
  List<DropdownMenuItem<String>> get dropdownPurposeItems{
    List<DropdownMenuItem<String>> statuses = [
      const DropdownMenuItem(value: "Sample", child: Text("Sample")),
      const DropdownMenuItem(value: "Demo", child: Text("Demo")),
      const DropdownMenuItem(value: "Discussion", child: Text("Discussion")),
      const DropdownMenuItem(value: "Revisit", child: Text("Revisit")),
    ];
    return statuses;
  }

  List<DropdownMenuItem<String>> selectedTypeList = [];
  String selectedType = '';

  void _selectedTypeList() async{
    selectedTypeList.clear();
    selectedType = '';
    selectedTypeList.add(const DropdownMenuItem(value: '', child: Text('')));
    var types = await WebRequests().getSelectedTypeListForCustomerOrLead(type);
    for(int i=0; i<types.length; i++){
      selectedTypeList.add(DropdownMenuItem(
          value: types[i]['value'],
          child: Text(types[i]['value'])
      ));
    }
    setState(() {

    });
  }

  List<DropdownMenuItem<String>> employeeList = [];
  String employee = '';

  void _getEmployeeList() async{
    employeeList.clear();
    employeeList.add(const DropdownMenuItem(value: '', child: Text('')));
    var types = await WebRequests().getEmployeesList();
    for(int i=0; i<types.length; i++){
      employeeList.add(DropdownMenuItem(
          value: types[i]['value'],
          child: Text(types[i]['value'])
      ));
    }
    setState(() {

    });
  }



  Text _customTextField(String label,bool isMandatory){
    return Text.rich(
      TextSpan(
        text: label,
        children: <InlineSpan>[
          TextSpan(
            text: isMandatory ? '*':'',
            style: const TextStyle(color: Colors.red),
          ),
        ],
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }

  BoxDecoration _textFieldDecoration(){
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.grey.withOpacity(0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
      const Duration(milliseconds: 300),
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
                    child: InkWell(
                      onTap: () async {
                        widget.model.isSiteCheckin =
                        !widget.model.isSiteCheckin;
                        widget.model.isCheckin = false;
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
                                  "type": type,
                                  "customer_lead" : selectedType,
                                  "joint_checkin" : employee,
                                  "purpose_of_visit" : purpose
                                }
                              },
                              HOME.WebRequests().checkinUser(bodyData).then((value) => {
                                if(value['message']['location_status'] == 1){
                                  HOME.WebRequests().uploadImage(employeePhotoCompressed,value['message']['name'],widget.empId).then((value) => {
                                    btmSheet!(() {
                                      isAttendanceMarked = true;
                                      locationStatus = true;
                                    }),
                                  }),

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
                              backgroundColor: Colors.white,
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
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF006CB5),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          widget.model.checkinString == 'IN'
                              ? 'Swipe to Site Check-in'
                              : 'Swipe to Site Check-out',
                          style: const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
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
                  )
                ],
              )

            ],
          ),
          _customTextField('Type', false),
          const SizedBox(height: 5,),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: _textFieldDecoration(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: type,
                onChanged: (String? newValue){
                  setState(() {
                    type = newValue!;
                    _selectedTypeList();
                  });
                },
                items: dropdownTypeItems,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          _customTextField('Customer/Lead', false),
          const SizedBox(height: 5,),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: _textFieldDecoration(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: selectedType,
                onChanged: (String? newValue){
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: selectedTypeList,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          _customTextField('Purpose of Visit', false),
          const SizedBox(height: 5,),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: _textFieldDecoration(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: purpose,
                onChanged: (String? newValue){
                  setState(() {
                    purpose = newValue!;
                  });
                },
                items: dropdownPurposeItems,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          _customTextField('Joint Checkin', false),
          const SizedBox(height: 5,),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: _textFieldDecoration(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: employee,
                onChanged: (String? newValue){
                  setState(() {
                    employee = newValue!;
                  });
                },
                items: employeeList,
              ),
            ),
          ),
        ],
      ),
    );
  }
}