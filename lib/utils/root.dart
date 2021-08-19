import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/authController.dart';
import 'package:gider_defteri/views/expense_view.dart';
import 'package:gider_defteri/views/home_view.dart';

class Root extends StatelessWidget {
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        _authController.userCredential == null ? HomeView() : ExpenseView());
  }
}
