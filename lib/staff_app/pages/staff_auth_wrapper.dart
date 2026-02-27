import 'package:flutter/material.dart';
import 'package:student_app/staff_app/pages/home_dashboard_page.dart';
import 'package:student_app/staff_app/pages/login_page.dart';
import 'package:student_app/staff_app/utils/get_storage.dart';

/// Auth guard for the Staff app.
/// Shows [HomeDashboardPage] when the user is already logged in,
/// otherwise shows [LoginPage]. The SplashPage navigates here after
/// its 3-second delay so the user never sees the login screen if they
/// already have a valid session stored.
class StaffAuthWrapper extends StatelessWidget {
  const StaffAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final bool loggedIn = AppStorage.isLoggedIn();
    return loggedIn ? const HomeDashboardPage() : const LoginPage();
  }
}
