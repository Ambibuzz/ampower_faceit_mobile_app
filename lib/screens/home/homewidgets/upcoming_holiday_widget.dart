import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../base_view.dart';
import '../viewmodel/homescreen_viewmodel.dart';

class UpcomingHolidayWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BaseView<HomeScreenViewModel>(
      onModelReady: (model){

      },
      onModelClose: (model){

      },
      builder: (context, model,child){
        return Container(
          margin:
          const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 1.0,
                  spreadRadius: 1, //New
                )
              ]),
          child: Column(
            children: [
              ...List.generate(model.current_holidays.length,
                      (index) {
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: model.current_holidays.length - 1 ==
                              index
                              ? 0
                              : 10),
                      child: Row(
                        children: [
                          Text(
                            '${model.current_holidays[index]['holiday_date']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF006CB5)),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          HtmlWidget(
                              model.current_holidays[index]
                              ['description']!,
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF006CB5)))
                        ],
                      ),
                    );
                  })
            ],
          ),
        );
      },
    );
  }
}