import 'package:community/components/global_styles/strip_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceStrip extends StatelessWidget{
  final String fromDate;
  final String toDate;
  final String description;
  AttendanceStrip({
    required this.fromDate,
    required this.toDate,
    required this.description
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
                      child: const Icon(Icons.person,color: Colors.white,),
                    )
                  ],
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description,style: const TextStyle(fontSize: 20,color: Color(0xFF006CB5)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: Text('$fromDate - $toDate',style: const TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}