import 'dart:convert';

import 'package:hive/hive.dart';

class ExpenseClaimCache {
  Future<dynamic> getAllExpenseClaims() async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      var tempClaims = await doctypeBox.get('ExpenseClaim',defaultValue: false);
      return tempClaims;
    } catch (e) {
      return false;
    }
  }

  Future<void> putAllExpenseClaimsInCache(expenseClaims) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('ExpenseClaim', jsonEncode(expenseClaims));
    } catch(e) {

    }
  }

  Future<dynamic> getExpenseClaimDetailsFromCache(docName) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      var tempDetails = await doctypeBox.get('ExpenseClaim-${docName}',defaultValue: false);
      return tempDetails;
    } catch(e) {
      return false;
    }
  }

  Future<void> putExpenseClaimDetailsInCache(docName,details) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('ExpenseClaim-$docName',jsonEncode(details));
    } catch(e) {

    }
  }
}