import 'dart:convert';
import 'package:community/base_viewmodel.dart';
import 'package:community/router/routing_constants.dart';
import 'package:community/screens/home/cache/home_cache.dart';
import 'package:community/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import '../../../apis/common_api_request/common_api.dart';
import '../../../helpers/shared_preferences.dart';
import '../../../locator/locator.dart';
import '../../../utils/enums.dart';

class HomeScreenViewModel extends BaseViewModel{
  String? email;
  String empId = '';
  String name = '';
  String designation = '';
  String company = '';
  String holiday_list_name = "";
  bool isLoading = true;
  String image_url = '';
  dynamic image;
  bool employee = true;
  bool isLicenseValid = false;
  bool restrictUser = false;
  String checkinString = 'IN';
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int day = DateTime.now().day;
  var currentDate = DateTime.now();
  var daysPresent = 0;
  var daysAbsent = 0;
  var daysPartial = 0;
  var totalDays = 0;
  var daysLeave = 0;
  int totalNoOfDaysInTheMonth = 0;
  List<Map<String, String>> current_holidays = [];
  List<Map<String,String>> sorted_holidays_for_current_month = [];
  bool isCheckin = false;
  bool isSiteCheckin = false;
  bool enableSiteCheckin = false;
  var card_menu_data = [];
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;
  int noticeBoardIndex = 0;
  var filteredNoteList = [];

  void changeSupportState(bool isSupported) {
    if(isSupported) {
      supportState = SupportState.supported;
    } else {
      supportState = SupportState.unsupported;
    }
    notifyListeners();
  }

  Future<void> authenticate() async {
    bool authenticated = false;
    notifyListeners();
    try {
      isAuthenticating = true;
      authorized = 'Authenticating';
      notifyListeners();
      authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to continue',
          options: const AuthenticationOptions(
            stickyAuth: true,
          ),
          authMessages: [
            const AndroidAuthMessages(
              cancelButton: 'No thanks',
            ),
          ]);
      isAuthenticating = false;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
      isAuthenticating = false;
      authorized = 'Errorr - ${e.message}';
      notifyListeners();
      return;
    }
    authorized = authenticated ? 'Authorized' : 'Not Authorized';
    notifyListeners();
  }

  Future<bool> isSessionExpired() async{
    bool result = await CommonApiRequest().checkSession();
    return result;
  }

  Future<bool> isFaceITEnabled() async {
    bool result = await CommonApiRequest().isFaceITEnabled();
    return result;
  }


  void initApp(bool forcedResync) async {
    await authenticate();
    bool isSessionValid = await isSessionExpired();
    bool appEnabled = await isFaceITEnabled();
    if(isSessionValid && appEnabled){
      await initFeatures();
      await getUserDetails();
      await getRecentCheckin();
      await getMonthlyData(
          startDate: "${DateTime.now().year}-${DateTime.now().month}-01",
          endDate: "${DateTime.now().year}-${DateTime.now().month}-${daysInMonth(DateTime(year, month))}",
          force: forcedResync
      );
      await getHolidays(month, year, forcedResync, day);
      await getEmployeeProfilePhoto();
      isLoading  = false;
      notifyListeners();
    } else {
      if(!isSessionValid) {
        locator.get<NavigationService>().navigateTo(authScreen);
      } else {
        locator.get<NavigationService>().navigateTo(appDisabledScreen);
      }
    }
  }


  void initUserDetails(dynamic employeeData) {
    empId = employeeData['data'][0]['employee'] ?? '';
    name = employeeData['data'][0]['employee_name'] ?? '';
    designation = employeeData['data'][0]['designation'] ?? '';
    holiday_list_name = employeeData['data'][0]['holiday_list'] ?? '';
    company = employeeData['data'][0]['company'] ?? '';
  }


  Future<void> getUserDetails() async {
    var finalEmail = await getEmail(); //get user's email from login
    dynamic employeeData = await HomeCache().getUserDetailsFromCache(); //get employee data from cache
    if(employeeData == false) {
      employeeData = await CommonApiRequest().getEmpId(finalEmail!);
      if (employeeData != null && employeeData['data'].isNotEmpty) {
        initUserDetails(employeeData);
        HomeCache().putUserDetailsInCache(jsonEncode(employeeData));
      } else {
        employee = false;
      }
    } else {
      initUserDetails(jsonDecode(employeeData));
    }
    notifyListeners();
    return;
  }

  //get most recent check-in
  getRecentCheckin() async {
    CommonApiRequest().getMostRecentEmployeeCheckin(empId).then((value) {
      checkinString = value == 'IN' ? 'OUT' : 'IN';
      isCheckin = false;
      isSiteCheckin = false;
      notifyListeners();
    });
  }

  Future<void> getMonthlyData({String? startDate, String? endDate, required bool force}) async {
    dynamic attendanceDetails = await HomeCache().getMonthlyAttendanceFromCache(startDate!, endDate!);
    if (attendanceDetails == false || force) {
      attendanceDetails = await CommonApiRequest().getMonthlyAttendance(startDate, endDate, name) ?? [];
      if (attendanceDetails.isNotEmpty) {
        await HomeCache().putMonthlyAttendanceInCache(startDate, endDate, jsonEncode(attendanceDetails));
        await initAttendance(jsonEncode(attendanceDetails));
      }
    } else {
      await initAttendance(attendanceDetails);
    }
    notifyListeners();
  }

  Future<void> initAttendance(attendanceDetails) async {
    if(attendanceDetails.isEmpty) {
      return;
    }
    var empData = [];
    empData = jsonDecode(attendanceDetails.toString());
    daysPresent = 0;
    daysAbsent = 0;
    daysPartial = 0;
    if (empData.isNotEmpty) {
      for (int i = 0; i < empData.length; i++) {
        totalDays++;
        if (empData[i][11] == 'Present') {
          daysPresent += 1;
        } else if (empData[i][11] == 'Absent') {
          daysAbsent += 1;
        } else if (empData[i][11] == 'On Leave') {
          daysLeave += 1;
        } else {
          daysPartial += 1;
        }
      }
    }
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    totalNoOfDaysInTheMonth =
        firstDayNextMonth.difference(firstDayThisMonth).inDays;
    return totalNoOfDaysInTheMonth;
  }

  Future<void> sortCurrentMonthHoliday(holidays, month, day, year) async{
    DateFormat dateFormat = DateFormat("yyyy-M-d");
    DateTime dateTime = dateFormat.parse("$year-$month-$day");
    int holidayLimit = 8;
    current_holidays.clear();
    sorted_holidays_for_current_month.clear();
    for (int i = 0; i < holidays.length; i++) {
      if (DateTime.parse(holidays[i]['holiday_date']).month == month) {
        sorted_holidays_for_current_month.add({
          'holiday_date': holidays[i]['holiday_date'],
          'description': holidays[i]['description']
        });
      }
    }
    for (int i = 0; i < holidays.length; i++) {
      if (DateTime.parse(holidays[i]['holiday_date']).month >= month &&
          DateTime.parse(holidays[i]['holiday_date']).isAfter(dateTime) &&
          holidayLimit > 1) {
        current_holidays.add({
          'holiday_date': holidays[i]['holiday_date'],
          'description': holidays[i]['description']
        });
        holidayLimit--;
      }
    }
  }

  Future<void> getHolidays(int month, int year, bool force, int day) async {
    totalNoOfDaysInTheMonth = daysInMonth(DateTime(year, month));
    dynamic holidays = await HomeCache().getHolidayDetailsFromCache(month, year);
    if (holidays == false || force) {
      current_holidays.clear();
      holidays = await CommonApiRequest().getMonthlyHolidays(holiday_list_name);
      if(holidays.isNotEmpty){
        await HomeCache().putHolidayDetailsInCache(month, year, jsonEncode(holidays));
        await sortCurrentMonthHoliday(holidays, month, day, year);
      }
    } else {
      await sortCurrentMonthHoliday(jsonDecode(holidays), month, day, year);
    }
    notifyListeners();
  }

  Future<void> initFeatures() async{
    //features = jsonDecode(features);
    image_url = '';//features['company_logo'] ?? '';
    card_menu_data.clear();
    // if (features['site_checkin'] == 1) {
    //   enableSiteCheckin = true;
    // } else {
    //   enableSiteCheckin = false;
    // }
    card_menu_data.add({
      'title': 'Past attendance request',
      'image': 'assets/images/apply_for_leave.png',
      'gradient_col1': 0xFF9DFFB2,
      'gradient_col2': 0xFFC9FFD5,
      'icon': Icons.history_toggle_off_sharp
    });
    card_menu_data.add({
      'title': 'Apply for leave',
      'image': 'assets/images/apply_for_leave.png',
      'gradient_col1': 0xFF9DFFB2,
      'gradient_col2': 0xFFC9FFD5,
      'icon': Icons.logout
    });
    card_menu_data.add({
      'title': 'Expense claim',
      'image': 'assets/images/expense_claim.png',
      'gradient_col1': 0xFFFF8C8C,
      'gradient_col2': 0xFFFFC2C2,
      'icon': Icons.money
    });
    card_menu_data.add({
      'title': 'Issue tracker',
      'image': 'assets/images/immigration.png',
      'gradient_col1': 0xFF81FFE8,
      'gradient_col2': 0xFFC6FFF5,
      'icon': Icons.bug_report
    });
    card_menu_data.add({
      'title': 'Salary slips',
      'image': 'assets/images/wallet.png',
      'gradient_col1': 0xFF81FFE8,
      'gradient_col2': 0xFFCAFFF5,
      'icon': Icons.currency_rupee
    });
    card_menu_data.add({
      'title': 'Attendance record',
      'image': 'assets/images/attendance_marking.png',
      'gradient_col1': 0xFFFFC875,
      'gradient_col2': 0xFFFFE2B8,
      'icon': Icons.person
    });
    card_menu_data.add({
      'title': 'Todo lists',
      'image': 'assets/images/todo_list.png',
      'gradient_col1': 0xFFA193FF,
      'gradient_col2': 0xFFD7D1FF,
      'icon': Icons.today_outlined
    });
    card_menu_data.add({
      'title': 'Timesheet',
      'image': 'assets/images/schedule.png',
      'gradient_col1': 0xFFA193FF,
      'gradient_col2': 0xFFD7D1FF,
      'icon': Icons.timelapse_sharp
    });
    notifyListeners();
  }

  String getSalutation(name) {
    var now = DateTime.now(); // Get current time in UTC timezone
    var formatter = DateFormat('HH');
    var hour = int.parse(formatter.format(now));

    String salutation;
    String emoji;

    if (hour >= 5 && hour < 12) {
      salutation = 'Good Morning, $name';
      emoji = '☀️';
    } else if (hour >= 12 && hour < 17) {
      salutation = 'Good Afternoon, $name';
      emoji = '🌤️';
    } else {
      salutation = 'Good Evening, $name';
      emoji = '🌙';
    }

    return '$salutation $emoji';
  }

  filterNotices(notelist){
    // Get the current date and time
    var now = DateTime.now();
    for(int i=0; i<notelist.length; i++){
      if(DateTime.parse(notelist[i]['valid_till']).isAfter(now) && notelist[i]['notify_on_faceit'] == 1){
        filteredNoteList.add(notelist[i]);
      }
    }
    notifyListeners();
  }


  void incrementNoticeBoardIndex() {
    noticeBoardIndex++;
    notifyListeners();
  }

  void decrementNoticeBoardIndex() {
    noticeBoardIndex--;
    notifyListeners();
  }

  void changeCheckinState() {
    isCheckin = !isCheckin;
    isSiteCheckin = false;
    notifyListeners();
  }

  Future<void> getEmployeeProfilePhoto() async {
    CommonApiRequest().employeeDetails().then((value) {
      if (value![0]['image'] != null) {
        CommonApiRequest().getEmployeeProfilePhoto(value[0]['image']).then((value) {
          image = value;
          notifyListeners();
        });
      }
    });
  }

  void navigateToPage(String title) {
    switch (title) {
      case 'Apply for leave':
        locator.get<NavigationService>().navigateTo(leaveApplicationScreen);
        break;
      case 'Expense claim':
        locator.get<NavigationService>().navigateTo(expenseClaimScreen);
        break;
      case 'Issue tracker':
        locator.get<NavigationService>().navigateTo(issueTrackerScreen);
        break;
      case 'Salary slips':
        locator.get<NavigationService>().navigateTo(salarySlipScreen);
        break;
      case 'Attendance record':
        locator.get<NavigationService>().navigateTo(attendancerecordScreen);
        break;
      case 'Timesheet':
        locator.get<NavigationService>().navigateTo(timesheetScreen);
        break;
      case 'Past attendance request':
        locator.get<NavigationService>().navigateTo(pastAttendanceScreen);
        break;
      case 'Search Employees':
        locator.get<NavigationService>().navigateTo(employeeSearchScreen);
        break;
      case 'Todo lists':
        locator.get<NavigationService>().navigateTo(todolistScreen);
        break;
      case 'Task list':
        locator.get<NavigationService>().navigateTo(tasklistScreen);
        break;
      default:
        locator.get<NavigationService>().navigateTo(''); // Fallback page
    }
  }

}