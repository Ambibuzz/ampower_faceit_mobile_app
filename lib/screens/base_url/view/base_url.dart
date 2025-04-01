import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../base_view.dart';
import '../../../components/black_button/black_button.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/toast.dart';
import '../viewmodel/base_url_viewmodel.dart';


class BaseURL extends StatelessWidget {
  const BaseURL({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseView<BaseUrlViewModel>(
      onModelReady: (model) async{
        model.getBaseurlFromLocalStorage();
      },
      onModelClose: (model) async{

      },
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50,),
                        Image.asset(
                          "assets/images/ambibuzz_icon.png",
                          width: 150,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 40,),
                        Text('Welcome!',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 32),),
                        const SizedBox(height: 10,),
                        const Text('Please set the default url',style: TextStyle(fontWeight: FontWeight.bold),),
                        Form(
                            key: model.formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                      controller: model.baseUrlController,
                                      keyboardType: TextInputType.url,
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                        hintText: 'Enter the default site url',
                                        hintStyle: const TextStyle(fontSize: 14),
                                        label: Text('Default site url'),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.black, width: 2),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(20))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey[300]!, width: 1),
                                            borderRadius:
                                            const BorderRadius.all(Radius.circular(20))),
                                      ),
                                      validator: (String? baseURL) {
                                        if (baseURL!.isEmpty) {
                                          return 'Default site url is required';
                                        }
                                        else if (!RegExp(r"((http|https)://)(www\.)?[a-zA-Z0-9-@:%._\+~#?&//=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%._\+~#?&//=]*)").hasMatch(baseURL)) {
                                          return 'Please enter a valid default site url';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? baseUrl) {

                                      }),
                                  const SizedBox(height: 5,),
                                  const Text('Example: https://erp.yoursite.com',style: TextStyle(color: Colors.grey),),

                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: raisedBlackButtonStyle,
                                            onPressed: () async{
                                              if (model.formKey.currentState!.validate()) {
                                                if (model.baseUrlController.text != '') {
                                                  if(model.baseUrlController.text.endsWith("/")){
                                                    model.baseUrlController.text = model.baseUrlController.text.substring(0, model.baseUrlController.text.length - 1);
                                                  }
                                                  model.setBaseURLAndNavigateToAuthScreen(model.baseUrlController.text);
                                                } else {
                                                  fluttertoast(
                                                      context, 'Please enter a valid url.');
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Update',
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w400,
                                                      color: themeBlack)),
                                            )),
                                      ),
                                      const SizedBox(width: 20,),
                                      Expanded(
                                        child: ElevatedButton(
                                            style: raisedBlackButtonStyle,
                                            onPressed: () {
                                              if (model.baseUrlController.text != '') {
                                                if(model.baseUrlController.text.endsWith("/")){
                                                  model.baseUrlController.text = model.baseUrlController.text.substring(0, model.baseUrlController.text.length - 1);
                                                }
                                                model.setBaseURLAndNavigateToAuthScreen(model.baseUrlController.text);
                                              } else {
                                                fluttertoast(
                                                    context, 'Please set a base url.');
                                              }
                                            },
                                            child: Text(
                                              'Continue',
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w400,
                                                      color: themeBlack)),
                                            )),
                                      )
                                    ],
                                  )
                                ])),
                      ],
                    )),
              ),
              model.settingBaseUrl ?
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.1),
                child: Center(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xff006CB5),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: 20,),
                        Text("Please wait while we set the base url...")
                      ],
                    ),
                  ),
                ),
              ):Container(),

            ],
          ),
        );
      },
    );
  }
}
