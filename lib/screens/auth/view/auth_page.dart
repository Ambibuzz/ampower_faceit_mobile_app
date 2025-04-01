
import 'package:flutter/material.dart';

import '../../../base_view.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/toast.dart';
import '../../../locator/locator.dart';
import '../../../router/routing_constants.dart';
import '../../../service/navigation_service.dart';
import '../viewmodel/authpage_viewmodel.dart';

class AuthPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BaseView<AuthPageViewModel>(
      onModelReady: (model) async {

      },
      onModelClose: (model) async {

      },
      builder: (context,model,child){
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50,),
                    Image.asset(
                      "assets/images/ambibuzz_icon.png",
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 40,),
                    Text('Welcome!',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 32),),
                    const SizedBox(height: 10,),
                    const Text('Login to your account',style: TextStyle(fontWeight: FontWeight.bold),),
                    Form(
                        key: model.formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                  controller: model.emailController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    label: Text('Email'),
                                    hintText: 'Enter your email address',
                                    hintStyle: const TextStyle(fontSize: 14),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                  ),
                                  validator: (String? email) {
                                    if (email!.isEmpty) {
                                      return 'Phone or Email is required';
                                    } else if (!RegExp(
                                        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(model.emailController.text)) {
                                      return 'Please enter a valid Email';
                                    }
                                    return null;
                                  },
                                  onSaved: (String? email) {
                                    email = email;
                                  }),
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  TextFormField(
                                      controller: model.passwordController,
                                      obscureText: model.obscureText,
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                        hintText: 'Enter your password',
                                        label: Text('Password'),
                                        hintStyle: const TextStyle(fontSize: 14),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black, width: 2),
                                            borderRadius: BorderRadius.all(Radius.circular(20))),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                        ),
                                      ),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Password is required';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        model.password = value;
                                      }),
                                  IconButton(
                                    icon: !model.obscureText
                                        ? const Icon(Icons.visibility,
                                        color: Color(0xff006CB5))
                                        : Icon(Icons.visibility_off, color: themeBlack),
                                    onPressed: () {
                                      model.changePasswordVisibility();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  if(model.isLoggingIn){
                                    return;
                                  }

                                  if (model.emailController.text != '' && model.passwordController.text != '') {
                                    model.authenticateEmployee(model.emailController.text, model.passwordController.text,context);
                                  } else {
                                    fluttertoast(
                                        context, 'Details not entered properly.');
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: model.isLoggingIn ? Colors.grey : Color(0xff006CB5)
                                  ),
                                  child: Center(
                                    child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700),),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              InkWell(
                                  onTap: () {
                                    locator.get<NavigationService>().navigateTo(baseUrl);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text('Update your ERP URL',style: TextStyle(color: Color(0xff006CB5),fontSize: 20,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                    ),
                                  )
                              ),
                              const SizedBox(height: 200,),
                              Container(
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/powered_by_ambibuzz.png",
                                    width: 150,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ])),
                  ],
                )),
          ),
        );
      },
    );
  }
}
