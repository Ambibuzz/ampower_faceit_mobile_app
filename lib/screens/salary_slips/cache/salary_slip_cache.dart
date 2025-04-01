import 'package:hive/hive.dart';

class SalarySlipCache {
  Future<dynamic> getSalarySlipFromCache() async {
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      var tempSlips = await doctypeBox.get('SalarySlip',defaultValue: false);
      return tempSlips;
    } catch(e) {
      return false;
    }
  }

  Future<void> putSalarySlipInCache(salarySlips) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('SalarySlip', salarySlips);
    } catch(e) {

    }
  }

  Future<dynamic> getSalarySlipDetailsFromCache(String docName) async{
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      var tempDetails = await doctypeBox.get('SalarySlipDetails-${docName}',defaultValue: false);
      return tempDetails;
    } catch(e){
      return false;
    }
  }

  Future<void> putSalarySlipDetailsInCache(docName,salarySlipDetails) async{
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('SalarySlipDetails-$docName', salarySlipDetails);
    } catch(e){

    }
  }
}