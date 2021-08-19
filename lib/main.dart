import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/authController.dart';
import 'package:gider_defteri/controllers/expenseController.dart';
import 'package:gider_defteri/views/expense_view.dart';
import 'package:gider_defteri/views/login_view.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'utils/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initControllers();
  runApp(MyApp());
}

void initControllers() {
  Get.put(ExpenseController());
  Get.put(AuthController());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr-TR');
    return GetMaterialApp(
      title: 'Gider Defteri',
      initialRoute: '/root',
      getPages: [
        GetPage(name: '/root', page: () => Root()),
        GetPage(name: '/home', page: () => ExpenseView()),
        GetPage(name: '/login', page: () => LoginView()),
      ],
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
