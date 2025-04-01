import 'dart:typed_data';
import 'package:community/base_view.dart';
import 'package:community/components/global_styles/text_field_design.dart';
import 'package:community/locator/locator.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/profile/viewmodel/profilepage_viewmodel.dart';
import 'package:community/utils/Urls.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();
  @override
  Widget build(BuildContext context){
    return BaseView<ProfilePageViewModel>(
      onModelReady: (model) async {
        model.getEmployeeDetails();
      },
      onModelClose: (model) async {

      },
      builder: (context,model,child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile',style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  homeScreenViewModel.image == null ?
                  const SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/user.png'),
                        ),
                      ),
                    ),
                  ):
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle
                    ),
                    child: ClipOval(
                      child: Image.memory(Uint8List.fromList(homeScreenViewModel.image),fit: BoxFit.fill,gaplessPlayback: true,),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: textFieldDecoration(),
                    child: TextField(
                      controller: model.firstName,
                      enabled: false,
                      decoration: inputDecoration('First Name', false),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: textFieldDecoration(),
                    child: TextField(
                      controller: model.lastName,
                      enabled: false,
                      decoration: inputDecoration('Last Name', false),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: textFieldDecoration(),
                    child: TextField(
                      controller: model.email,
                      enabled: false,
                      decoration: inputDecoration('Email', false),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: textFieldDecoration(),
                    child: TextField(
                      controller: model.phoneNumber,
                      enabled: false,
                      decoration: inputDecoration('Phone Number', false),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: textFieldDecoration(),
                    child: TextField(
                      controller: model.company,
                      enabled: false,
                      decoration: inputDecoration('Company', false),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: textFieldDecoration(),
                    child: TextField(
                      controller: model.department,
                      enabled: false,
                      decoration: inputDecoration('Department', false),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: textFieldDecoration(),
                    child: TextField(
                      controller: model.designation,
                      enabled: false,
                      decoration: inputDecoration('Designation', false),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      model.logoutUser();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF006CB5)
                      ),
                      child: Center(
                        child: Text('Log out',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text("v${AppVersion.version}",style: TextStyle(color: Colors.black),),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}