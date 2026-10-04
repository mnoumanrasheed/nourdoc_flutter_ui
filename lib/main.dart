import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/doctor_signup/doctor_signup_screen.dart';

void main() => runApp(const NourDocApp());

class NourDocApp extends StatelessWidget {
  const NourDocApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NourDoc',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const DoctorSignupScreen(),
  );
}
