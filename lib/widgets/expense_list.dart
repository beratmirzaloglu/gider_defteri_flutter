import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/expenseController.dart';

import 'expense_item.dart';

class ExpenseList extends StatelessWidget {
  final _expenseController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: _expenseController.expenses.isEmpty
            ? Column(
                children: [
                  Text('Gider bulunamadı.',
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ],
              )
            : ListView.builder(
                itemBuilder: (ctx, index) =>
                    ExpenseItem(_expenseController.expenses[index]),
                itemCount: _expenseController.expenses.length),
      ),
    );
  }
}
