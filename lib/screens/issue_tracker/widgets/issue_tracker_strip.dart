import 'package:community/components/global_styles/strip_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

class IssueTrackerStrip extends StatelessWidget{
  final String description;
  final String status;
  final String priority;


  IssueTrackerStrip({
    required this.description,
    required this.status,
    required this.priority
  });

  @override
  Widget build(BuildContext context) {
    return stripStyle(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Color(0xFF006CB5),
                          shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.logout_outlined,color: Colors.white,),
                    )
                  ],
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Description: '),
                      const SizedBox(height: 5,),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 44,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        child: SingleChildScrollView(
                          child: HtmlWidget(description),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text('Priority: $priority'),
                      // const SizedBox(height: 10,),
                      // Text('Total Claimed Amount: ₹${totalClaimedAmount}')
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10,),
          Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color:  status == 'Open' ? const Color(0xFFF6B4B4) :
                status == 'Rejected' ? const Color(0xFFF6B4B4) :
                status == 'Cancelled' ? const Color(0xFFC7F2D7) : const Color(0xFFC7F2D7),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                status,
                style: TextStyle(
                    color: status == 'Open' ? const Color(0xFFC52F2F) :
                    status == 'Rejected' ? const Color(0xFFC52F2F) :
                    status == 'Cancelled' ? Colors.green : Colors.green,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}