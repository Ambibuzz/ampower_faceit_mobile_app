import 'package:community/base_viewmodel.dart';
import 'package:community/screens/notification/api_requests/web_requests.dart';

class NotificationViewModel extends BaseViewModel{
  var notelist = [];

  void getNoteList() async {
    notelist = await WebRequests().getNoteList('');
    notifyListeners();
  }
}