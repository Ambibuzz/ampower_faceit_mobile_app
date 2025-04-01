import 'package:community/components/global_styles/strip_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalarySlipStrip extends StatelessWidget{
  final String name;
  final String postingDate;
  final String netPay;
  final String status;

  SalarySlipStrip({
    required this.name,
    required this.postingDate,
    required this.netPay,
    required this.status
});

  @override
  Widget build(BuildContext context) {
    return stripStyle(child: Row(
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
                    child: const Icon(Icons.currency_rupee,color: Colors.white,),
                  )
                ],
              ),
              const SizedBox(width: 20,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: const TextStyle(fontSize: 14,color: Color(0xFF006CB5),fontWeight: FontWeight.w700),),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        FittedBox(child: Text('₹ $netPay',style: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w500),),),
                        Expanded(child: Container(),),
                        FittedBox(child: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(postingDate)),style: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w500),),)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}