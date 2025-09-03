import 'package:community/base_view.dart';
import 'package:community/screens/auth/viewmodel/appdisabled_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDisabled extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<AppDisabledViewModel>(
      onModelReady: (model) {

      },
      onModelClose: (model) {

      },
      builder: (context,model,child) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(20),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'FaceIT is currently disabled. Please enable it from the configuration and retry again.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    model.checkConfig();
                  },
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: model.isCheckingApp ? Colors.grey : Color(0xff006CB5)
                    ),
                    child: Center(
                      child: Text('Retry',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w700),),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}