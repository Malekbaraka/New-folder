import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/employee_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/employee_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => EmployeeProvider()),
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder:
            (context, themeProvider, child) => MaterialApp(
              title: 'إدارة المشفى',
              theme: themeProvider.themeData,
              // تعيين اتجاه التطبيق من اليمين إلى اليسار للغة العربية
              locale: const Locale('ar', 'SA'),
              supportedLocales: const [Locale('ar', 'SA')],
              // إضافة حزم الترجمة لدعم اللغة العربية
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const EmployeeListScreen(),
              debugShowCheckedModeBanner: false,
              // إضافة تكوين لضمان توافق الشاشات
              builder: (context, child) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!,
                  ),
                );
              },
            ),
      ),
    );
  }
}
