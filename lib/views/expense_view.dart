import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/authController.dart';
import 'package:gider_defteri/controllers/expenseController.dart';
import 'package:gider_defteri/widgets/expense_list.dart';

import '../widgets/chart.dart';

class ExpenseView extends StatefulWidget {
  @override
  _ExpenseViewState createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  final _expenseController = Get.find<ExpenseController>();
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    print('initstate');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Gider Defteri'),
          actions: [
            IconButton(
              onPressed: () {
                _expenseController.showAddExpenseModal(context);
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                _authController.signOutWithGoogle();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Chart(),
            ExpenseList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _expenseController.showAddExpenseModal(context);
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
