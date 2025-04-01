import 'package:flutter/material.dart';
import '../../../base_view.dart';
import '../viewmodel/homescreen_viewmodel.dart';

class QuickLinkWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BaseView<HomeScreenViewModel>(
      onModelReady: (model){

      },
      onModelClose: (model){

      },
      builder: (context, model,child){
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 1.0,
                spreadRadius: 1, //New
              )
            ],
          ),
          child: ReorderableListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) {
              print('*****');
              print(oldIndex);
              print(newIndex);
            },
            children: [
              ...List.generate(model.card_menu_data.length,
                      (index) {
                    return InkWell(
                      key: ValueKey(model.card_menu_data[index]['title']),
                      onTap: () {
                        model.navigateToPage(model.card_menu_data[index]['title']);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  model.card_menu_data[index]['icon'],
                                  color:
                                  const Color(0xFF006CB5),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  model.card_menu_data[index]['title'],
                                  style: const TextStyle(
                                      color: Color(0xFF006CB5)),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                            model.card_menu_data.length - 1 != index
                                ? const Divider(
                              color: Colors.grey,
                            )
                                : Container()
                          ],
                        ),
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